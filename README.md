# rebar3_mommy

A rebar3 version of [cargo-mommy](https://github.com/Gankra/cargo-mommy).

## Use

Add the plugin to your `rebar.config`:

```erlang
{plugins, [{rebar3_mommy, {git, "https://github.com/trueFireblade/rebar3_mommy", {branch, "master"}}}]}.
```

Then just call your plugin directly in an existing application:
```sh
$ rebar3 mommy <commands>
```

## Configuration

Add a `rebar3_mommy` section to your `rebar.config`:

```erlang
{rebar3_mommy, [
  {little, "girl"},
  {pronouns, "her"},
  {roles, "mommy"}
]}.
```
- `little`: what to call you (default "girl")
- `pronouns`: what pronouns to use for themselves (default "her")
- `roles`: what role they have (default "mommy")

Each of these options can be left out, be a string or a `/` seperated list of options(e.g. `{pronouns, "her/their"}`).

## Why

This plugin serves no real purpose whatsoever! It was purely created out of boredom and to fiddle a bit with writing a rebar plugin.
