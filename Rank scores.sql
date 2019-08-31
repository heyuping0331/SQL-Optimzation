

-- leetcode 178 Rank Scores

-- dense_rank() vs rank()
SELECT 
    Score
    ,dense_rank() over(order by Score desc) AS Rank
FROM Scores
