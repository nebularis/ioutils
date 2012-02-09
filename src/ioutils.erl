%% Copyright (c) 2012 Nebularis.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
-module(ioutils).
-compile(export_all).

-type process_type()        :: 'registered' | 'global' | 'io'.
-type process_id()          :: {process_type(), pid()} | pid().
-type resource_type()       ::  'application'  | 'library' |
                                'package'      | 'module'  |
                                'function'     | 'file'.
-type resource_version()    :: string().
-type resource_id()         :: atom() | {atom(), resource_version()} | term().
-type resource_location()   :: string() | process_id() | 'undefined'.

-export_type([process_id/0,
              process_type/0,
              resource_type/0,
              resource_version/0,
              resource_id/0,
              resource_location/0]).

-include("ioutils.hrl").

resolve(Query) ->
    ioutils_resource_resolver:resolve(any, Query, default).

search_path() ->
    [code:lib_dir()|erl_libs()].

installed_applications() ->
    %% TODO: verify app dirs...
    case application:get_env(ioutils, {?MODULE, lib_paths}) of
        {ok, Path} ->
            Path;
        _ ->
            ToCache = lib_paths(search_path()),
            application:set_env(ioutils, {?MODULE, lib_paths}, ToCache),
            ToCache
    end.

lib_paths(LibDirs) ->
    Found = lists:foldl(fun capture_app_dir/2, ordsets:new(), code:get_path()),
    AppSet = lists:foldl(fun capture_sub_dirs/2, Found, LibDirs),
    ordsets:to_list(AppSet).

capture_sub_dirs(Dir, Acc) ->
    case file:list_dir(Dir) of
        {ok, SubDirs} ->
            lists:foldl(fun capture_app_dir/2, Acc, SubDirs);
        _ ->
            Acc
    end.

capture_app_dir(".", AppSet) ->
    AppSet;
capture_app_dir(Dir, AppSet) ->
    case filelib:is_dir(Dir) of
        true ->
            DirName = case filename:basename(Dir) of
                "ebin" -> filename:dirname(Dir);
                _ -> Dir
            end,
            ordsets:add_element(filename:basename(DirName), AppSet);
        false ->
            AppSet
    end.

erl_libs() ->
    case os:getenv("ERL_LIBS") of
        false -> [];
        LibDirs -> split_dirs(LibDirs)
    end.

split_dirs(LibDirs) ->
    Sep = case os:type() of
        {win32, _} -> ";";
        _ -> ":"
    end,
    string:tokens(LibDirs, Sep).
