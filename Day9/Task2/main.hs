import Data.Char ()
import Data.List (sort)
import qualified Data.Set as Set

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

getBasinSizes :: [[Int]] -> [(Int, Int)] -> [Int]
getBasinSizes input = map (Set.size . findBasin input)

findBasin :: [[Int]] -> (Int, Int) -> Set.Set (Int, Int)
findBasin input (x, y) = search input (Set.singleton (x, y))

search :: [[Int]] -> Set.Set (Int, Int) -> Set.Set (Int, Int)
search input visited =
  if Set.null (neighborPoints input visited)
    then visited
    else search input (Set.union (neighborPoints input visited) visited)

neighborPoints :: [[Int]] -> Set.Set (Int, Int) -> Set.Set (Int, Int)
neighborPoints input visited = Set.filter (\point -> Set.notMember point visited && getPoint input point /= 9) $ foldl1 Set.union $ Set.map (getAdjacent input) visited

getAdjacent :: [[Int]] -> (Int, Int) -> Set.Set (Int, Int)
getAdjacent input (x, y) = Set.fromList [(x, y -1), (x, y + 1), (x -1, y), (x + 1, y)]

findBasins :: [[Int]] -> Int
findBasins input = product $ take 3 $ reverse $ sort $ getBasinSizes input $ findLows input

main :: IO ()
main = do
  result <- findBasins <$> getInput
  putStrLn ("Result: " ++ show result)