-module(rebar3_mommy_writer).
-export([warn/2, positive/1, negative_string/1]).
-include("rebar3_mommy.hrl").
-ignore_xref([{rebar_api, info, 2},
              {rebar_api, warn, 2}]).

-spec positives() -> [string()].
positives() -> [
    "*pets your head*",
    "you're such a smart cookie~ ❤️",
    "that's a good AFFECTIONATE_TERM~ ❤️",
    "MOMMYS_ROLE thinks MOMMYS_PRONOUN litle AFFECTIONATE_TERM earned a big hug~ ❤️",
    "good AFFECTIONATE_TERM~\nMOMMYS_ROLE's so proud of you~ ❤️",
    "awe, what a good AFFECTIONATE_TERM~\nMOMMYS_ROLE knew you could do it~ ❤️"
].

-spec negatives() -> [string()].
negatives() -> [
    "MOMMYS_ROLE believes in you~ ❤️",
    "do you need MOMMYS_ROLE's help?~ ❤️",
    "MOMMYS_ROLE still loves you no matter what~ ❤️",
    "oh no did MOMMYS_ROLE's little AFFECTIONATE_TERM make a big mess?~ ❤️",
    "MOMMYS_ROLE knows MOMMYS_PRONOUN little AFFECTIONATE_TERM can do better~ ❤️",
    "just a little further, sweetie~ ❤️"
].

-spec positive(#mommy_opts{}) -> ok.
positive(State) ->
    rebar_api:info("~ts", [format(get_random_elem(positives()), State)]).

-spec negative_string(#mommy_opts{}) -> iolist().
negative_string(State) ->
    format(get_random_elem(negatives()), State).

-spec warn(string(), #mommy_opts{}) -> ok.
warn(Text, State) ->
    rebar_api:warn("~ts", [format(Text, State)]).

-spec get_random_elem([any()]) -> any().
get_random_elem(Data) ->
    lists:nth(rand:uniform(length(Data)), Data).

-spec format(string(), #mommy_opts{}) -> iolist().
format(Text, State) ->
    Little = get_random_elem(State#mommy_opts.little),
    Pronoun = get_random_elem(State#mommy_opts.pronouns),
    Role = get_random_elem(State#mommy_opts.roles),
    LittleStr = string:replace(Text, "AFFECTIONATE_TERM", Little, all),
    PronounStr = string:replace(LittleStr, "MOMMYS_PRONOUN", Pronoun, all),
    string:replace(PronounStr, "MOMMYS_ROLE", Role, all).