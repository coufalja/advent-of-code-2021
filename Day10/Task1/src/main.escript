#!escript

-mode(compile).

main(_) ->
    Input = read_input("..\\input.txt"),
    Illegal = lists:foldl(fun find_illegal/2, [], Input),
    Score = lists:sum([score_illegal(I) || I <- Illegal]),
    io:format("illegal: ~p~n", [Score]).

score_illegal($)) -> 3;
score_illegal($]) -> 57;
score_illegal($}) -> 1197;
score_illegal($>) -> 25137.

find_illegal(Chunks, IllegalChars) ->
    case parse_chunks(Chunks) of
        'complete' -> IllegalChars;
        'incomplete' -> IllegalChars;
        {'illegal', IC} -> [IC | IllegalChars]
    end.

parse_chunks(Chunks) ->
    parse_chunks(Chunks, []).

parse_chunks(<<>>, []) -> 'complete';
parse_chunks(<<>>, _Stack) -> 'incomplete';
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

read_input(File) ->
    {'ok', Lines} = file:read_file(File),
    [Line || Line <- binary:split(Lines, <<"\n">>, ['global']), Line =/= <<>>].