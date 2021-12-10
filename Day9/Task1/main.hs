padInputLine :: Num a => [a] -> [a]
padInputLine xs = [9] ++ xs ++ [9]

getInput :: IO [[Int]]
getInput = do
  text <- readFile "..\\input.txt"
  let lineLength = length (head $ lines text) + 2
  return $ [take lineLength [9, 9 ..]] ++ map (padInputLine . map (read . (: []))) (lines text) ++ [take lineLength [9, 9 ..]]

getPoint :: [[a]] -> (Int, Int) -> a
getPoint xs (x, y) = (xs !! x) !! y

isLowPoint :: Ord a => [[a]] -> (Int, Int) -> Bool
isLowPoint input (x, y) = point < above && point < left && point < right && point < under
  where
    point = getPoint input (x, y)
    left = getPoint input (x -1, y)
    right = getPoint input (x + 1, y)
    above = getPoint input (x, y -1)
    under = getPoint input (x, y + 1)

findLows :: Ord a => [[a]] -> [(Int, Int)]
findLows input = filter (isLowPoint input) ([(x, y) | x <- [1 .. rows], y <- [1 .. cols]])
  where
    rows = length input - 2
    cols = length (head input) - 2

countLows :: (Num a, Ord a) => [[a]] -> a
countLows input = sum $ map (+ 1) $ [getPoint input p | p <- findLows input]

main :: IO ()
main = do
  lowPointsCount <- countLows <$> getInput
  putStrLn ("Result: " ++ show lowPointsCount)