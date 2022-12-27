%%% @doc Plugin provider for rebar3 mommy.
-module(rebar3_mommy_prv).

-export([init/1, do/1, format_error/1]).

-ignore_xref([do/1,
              format_error/1,
              {rebar_state, get, 3},
              {providers, create, 1},
              {rebar_state, add_provider, 2},
              {rebar_utils, args_to_tasks, 1},
              {rebar_state, command_args, 1},
              {rebar_state, command_parsed_args, 1}]).

-define(PROVIDER, mommy).
-define(DEPS, []).
-define(OPTS, []).
-include("rebar3_mommy.hrl").

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    Provider =
        providers:create([{name, ?PROVIDER}, % The 'user friendly' name of the task
                          {module, ?MODULE}, % The module implementation of the task
                          {bare, true},      % The task can be run by the user, always true
                          {deps, ?DEPS},     % The list of dependencies
                          {example, "rebar3 mommy commands"}, % How to use the plugin
                          {opts, ?OPTS},     % list of options understood by the plugin
                          {short_desc, "A rebar plugin"},
                          {desc, "A rebar plugin"}]),
    {ok, rebar_state:add_provider(State, Provider)}.

-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, term()}.
do(State) ->
    Vars = get_vars(State),
    case parse_opts(State) of
        [] ->
            rebar3_mommy_writer:warn("You need to tell MOMMYS_ROLE what you want to do~", Vars),
            {ok, State};
        Opts ->
            case rebar_prv_do:do_tasks(Opts, State) of
                {ok, State2} ->
                    rebar3_mommy_writer:positive(Vars),
                    {ok, State2};
                {error, {Module, Err}} ->
                    rebar_api:error("~ts", [apply(Module, format_error, [Err])]),
                    {error, {?MODULE, {failed, Vars}}}
            end
    end.

-spec format_error(any()) -> iolist().
format_error({failed, Vars}) ->
    rebar3_mommy_writer:negative_string(Vars).

-spec parse_opts(rebar_state:t()) -> [{string(), string()}].
parse_opts(State) ->
    rebar_utils:args_to_tasks(rebar_state:command_args(State)).

-spec get_vars(rebar_state:t()) -> #mommy_opts{}.
get_vars(State) ->
    ConfigRaw = maps:from_list(rebar_state:get(State, rebar3_mommy, [])),
    Little   = get_var(ConfigRaw, little, "girl"),
    Pronouns = get_var(ConfigRaw, pronouns, "her"),
    Roles    = get_var(ConfigRaw, roles, "mommy"),
    #mommy_opts{little = Little, pronouns = Pronouns, roles = Roles}.

-spec get_var(maps:map(), atom(), string()) -> [string()].
get_var(Config, Key, Default) ->
    string:split(maps:get(Key, Config, Default), "/", all).