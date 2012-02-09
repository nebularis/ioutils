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
-module(ioutils_resource_resolver_tests).
-include_lib("eunit/include/eunit.hrl").
-include_lib("hamcrest/include/hamcrest.hrl").

-include_lib("ioutils/include/ioutils.hrl").
-import(ioutils_resource_resolver, [application/1]).

pre_loaded_module_resolution_test_() ->
    [{"Applications are resolved to their lib_dir",
     ?_assertThat(application(ioutils),
        is(equal_to([#'ioutils.resource'{ id=ioutils,
                                         type=application,
                                         location=code:lib_dir(ioutils) }])))},
     {"Non-Existing Application are 'unresolved'",
     ?_assertThat(application(there_is_no_such_app_as_this),
        is(equal_to([])))}].

%with_mock(Mod, TestCase) ->
%    meck:new(Mod),
%    try
%        TestCase()
%    after
%        meck:unload(Mod)
%    end.
