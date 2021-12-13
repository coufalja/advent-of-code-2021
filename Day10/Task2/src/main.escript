#!escript

-mode(compile).

main(_) ->
    Input = read_input("..\\input.txt"),
    Failures = lists:foldl(fun find_failures/2, [], Input),
    Scores = [score_unwind(unwind_stack(Stack))
              || {'incomplete', Stack} <- Failures
             ],
    Middle = lists:nth((length(Scores) div 2) + 1, lists:sort(Scores)),
    io:format("incomplete: ~p~n", [Middle]).

find_failures(Chunks, Fails) ->
    case parse_chunks(Chunks) of
        'complete' -> Fails;
        {'incomplete', Stack} -> [{'incomplete', Stack} | Fails];
        {'illegal', IC} -> [{'illegal', IC} | Fails]
    end.

parse_chunks(Chunks) ->
    parse_chunks(Chunks, []).

parse_chunks(<<>>, []) -> 'complete';
parse_chunks(<<>>, Stack) -> {'incomplete', Stack};
parse_chunks(<<Open:8, Rest/binary>>, Stack)
  when Open =:= $[;
       Open =:= ${;
       Open =:= $(;
       Open =:= $<
       ->
    parse_chunks(Rest, [Open | Stack]);
parse_chunks(<<Close:8, Rest/binary>>, [Top | Stack]) ->
    case closes(Top, Close) of
        'true' -> parse_chunks(Rest, Stack);
        'false' -> {'illegal', Close}
    end.

closes(${, $}) -> 'true';
closes($[, $]) -> 'true';
closes($(, $)) -> 'true';
closes($<, $>) -> 'true';
closes(_, _) -> 'false'.

unwind_stack(Stack) ->
    [closing(Open) || Open <- Stack].

closing(${) -> $};
closing($[) -> $];
closing($() -> $);
closing($<) -> $>.

score_unwind(Unwind) ->
    lists:foldl(fun score_closing/2, 0, Unwind).

score_closing(Close, Total) ->
    (Total * 5) + score_close(Close).

score_close($)) -> 1;
score_close($]) -> 2;
score_close($}) -> 3;
score_close($>) -> 4.

read_input(File) ->
    {'ok', Lines} = file:read_file(File),
    [Line || Line <- binary:split(Lines, <<"\n">>, ['global']), Line =/= <<>>].