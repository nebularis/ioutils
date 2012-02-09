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
%% 
%% @doc Provides a mechanism for resolving <i>resources</i> at varying scopes
%% using a variety of search terms.
%% 
%% 
%% 
%% 
-module(ioutils_resource_resolver).

-include("ioutils.hrl").

-export([resolve/2]).
-export([application/1]).

%% resolve(module, "rebar_*"),
%% resolve(module, "*"),
%% resolve(Type, SearchTerm, Scope),
%% resolve(module, "rebar_*",
%%         installed(application("rebar-1.0")))
%%
%%
%% resolve(installed(application("rebar-1.0")), module, "rebar_*").
%% resolve_via(installed(application("rebar-1.0")), module, "rebar_*").
%% 
%% resolve(module, "rebar_*", within(installed, {application, "rebar-1.0"}))
%% resolve_in(installed(application, "rebar-1.0"), module, "rebar_*")
%% 
%% module("rebar_*", via(loaded(application("rebar-1.0")))
%% module(glob("rebar_*_plugin"),
%%     scope(one_of([loaded, 
%%                   installed(application(rxmatch("rebar_(.*)_plugin")))])))
%% 
%    => match term in code:all_loaded() or any application
%% 
%% application + module
%% resolve("ioutils/*_resolver.beam") => [#resource{ id=?MODULE, ... }]
%% 
%% application + version + filename
%% 
%% 
%% org + artefact (siv) + fnmatch
%% resolve("hyperthunk:ioutils/*_resolver") => ^
%% 
%% mod + func
%% resolve("*_plugin.beam:execute/3") => [Stuff]
%% 
%% 
%% 
%% 
%% 
%% 
%% 

%% application([H|_]=SearchTerm) when is_integer(H) ->
    
application(SearchTerm) when is_atom(SearchTerm) ->
    case code:lib_dir(SearchTerm) of
        {error, _} ->
            [];
        Loc when is_list(Loc) ->
            [#'ioutils.resource'{ id=SearchTerm,
                                  type='application',
                                  location=Loc }]
    end.

%resolve(Thing) ->
%    resolve Thing, ..... 

resolve(_Query, []) ->
    throw(empty_ruleset).

%resolve(module, SearchTerm, Scope) when is_atom(SearchTerm) ->
%    case code:which(SearchTerm) of
%        Location when is_list(Location) ->
%            Location
%    end.

