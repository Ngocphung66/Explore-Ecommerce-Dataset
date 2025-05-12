-- Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
SELECT
  FORMAT_TIMESTAMP('%Y%m', PARSE_TIMESTAMP('%Y%m%d', date)) AS month, -- Extract year-month in 'YYYYMM' format
  SUM(totals.visits) AS visits, -- Calculate total visits
  SUM(totals.pageviews) AS pageviews, -- Calculate total pageviews
  SUM(totals.transactions) AS transactions -- Calculate total transactions
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE
  _table_suffix BETWEEN '0101' AND '0331' -- Filter tables from January 1, 2017 to March 31, 2017
GROUP BY
  month -- Group by formatted month
ORDER BY
  month; -- Order results by month


-- Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
SELECT
  trafficSource.source AS source, -- Traffic source
  COUNT(totals.visits) AS total_visits, -- Total visits per traffic source
  COUNTIF(totals.bounces = 1) AS total_no_of_bounces, -- Count bounces where bounces = 1
  ROUND(COUNTIF(totals.bounces = 1) / COUNT(totals.visits) * 100, 3) AS bounce_rate -- Bounce rate calculation
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201707*` -- July 2017 data
WHERE
  totals.visits IS NOT NULL -- Ensure valid session data
GROUP BY
  trafficSource.source -- Group results by traffic source
ORDER BY
  total_visits DESC; -- Order results by total visits in descending order

-- Query 3: Revenue by traffic source by week, by month in June 2017
-- Monthly revenue
SELECT
  'Month' AS time_type, -- Indicate monthly aggregation
  FORMAT_TIMESTAMP('%Y%m', PARSE_TIMESTAMP('%Y%m%d', date)) AS time, -- Extract month in format 'YYYYMM'
  trafficSource.source AS source, -- Traffic source
  ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue -- Revenue in millions
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`, -- Tables for June 2017
  UNNEST(hits) AS hits, -- Unnest hits
  UNNEST(hits.product) AS product -- Unnest product to access productRevenue
WHERE
  product.productRevenue IS NOT NULL -- Filter only rows with valid product revenue
GROUP BY
  time_type, time, source

UNION ALL

-- Weekly revenue
SELECT
  'Week' AS time_type, -- Indicate weekly aggregation
  FORMAT_TIMESTAMP('%Y%V', PARSE_TIMESTAMP('%Y%m%d', date)) AS time, -- Extract week in format 'YYYYWW'
  trafficSource.source AS source, -- Traffic source
  ROUND(SUM(product.productRevenue) / 1000000, 4) AS revenue -- Revenue in millions
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`, -- Tables for June 2017
  UNNEST(hits) AS hits, -- Unnest hits
  UNNEST(hits.product) AS product -- Unnest product to access productRevenue
WHERE
  product.productRevenue IS NOT NULL -- Filter only rows with valid product revenue
GROUP BY
  time_type, time, source

ORDER BY
  time_type DESC, -- Sort by time type (Month first, then Week)
  time, -- Then by time within each type
  source; -- Finally, by traffic source

-- Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
WITH user_pageviews AS (
  SELECT
    FORMAT_TIMESTAMP('%Y%m', PARSE_TIMESTAMP('%Y%m%d', date)) AS month, -- Extract month as 'YYYYMM'
    fullVisitorId, -- User ID
    totals.pageviews AS total_pageviews, -- Total pageviews for the session
    CASE
      WHEN totals.transactions >= 1 AND product.productRevenue IS NOT NULL THEN 'purchaser'
      WHEN totals.transactions IS NULL AND product.productRevenue IS NULL THEN 'non_purchaser'
      ELSE NULL
    END AS user_type -- Classify users as purchaser or non-purchaser
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, -- Data from June and July 2017
    UNNEST(hits) AS hit, -- Unnest hits for processing
    UNNEST(hit.product) AS product -- Unnest products within hits
  WHERE
    totals.pageviews IS NOT NULL -- Ensure valid pageview data
),
aggregated_data AS (
  SELECT
    month,
    user_type,
    SUM(total_pageviews) AS total_pageviews, -- Total pageviews by user type
    COUNT(DISTINCT fullVisitorId) AS unique_users -- Number of unique users by user type
  FROM
    user_pageviews
  WHERE
    user_type IS NOT NULL -- Only valid user types
  GROUP BY
    month, user_type
)
SELECT
  month,
  ROUND(SUM(CASE WHEN user_type = 'purchaser' THEN total_pageviews ELSE 0 END) /
        SUM(CASE WHEN user_type = 'purchaser' THEN unique_users ELSE 0 END), 8) AS avg_pageviews_purchase,
  ROUND(SUM(CASE WHEN user_type = 'non_purchaser' THEN total_pageviews ELSE 0 END) /
        SUM(CASE WHEN user_type = 'non_purchaser' THEN unique_users ELSE 0 END), 8) AS avg_pageviews_non_purchase
FROM
  aggregated_data
GROUP BY
  month
ORDER BY
  month;

-- Query 05: Average number of transactions per user that made a purchase in July 2017
SELECT
  FORMAT_TIMESTAMP('%Y%m', PARSE_TIMESTAMP('%Y%m%d', date)) AS month, -- Extract month as 'YYYYMM'
  ROUND(SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId), 8) AS Avg_total_transactions_per_user -- Calculate average transactions per user
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, -- Table for July 2017
  UNNEST(hits) AS hits, -- Unnest hits to access product data
  UNNEST(hits.product) AS product -- Unnest products to check productRevenue
WHERE
  totals.transactions >= 1 -- Purchasers have at least one transaction
  AND product.productRevenue IS NOT NULL -- Ensure revenue exists
GROUP BY
  month
ORDER BY
  month;

-- Query 06: Average amount of money spent per session. Only include purchaser data in July 2017
SELECT
  FORMAT_TIMESTAMP('%Y%m', PARSE_TIMESTAMP('%Y%m%d', date)) AS month, -- Extract month as 'YYYYMM'
  ROUND(SUM(product.productRevenue) / 1000000 / COUNT(fullVisitorId), 2) AS avg_revenue_by_user_per_visit -- Calculate average revenue per session
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, -- Table for July 2017
  UNNEST(hits) AS hits, -- Unnest hits to access product data
  UNNEST(hits.product) AS product -- Unnest products to check productRevenue
WHERE
  totals.transactions IS NOT NULL -- Only include sessions with at least one transaction
  AND product.productRevenue IS NOT NULL -- Only include data with valid revenue
GROUP BY
  month
ORDER BY
  month;

-- Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
WITH customers_with_product AS (
  SELECT
    fullVisitorId
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, -- July 2017 data
    UNNEST(hits) AS hit, -- Expand hits
    UNNEST(hit.product) AS product -- Expand product within hits
  WHERE
    product.v2ProductName = "YouTube Men's Vintage Henley" -- Target product
    AND product.productRevenue IS NOT NULL -- Only include transactions with revenue
),
other_products_purchased AS (
  SELECT
    product.v2ProductName AS other_purchased_products, -- Name of other purchased products
    SUM(product.productQuantity) AS quantity -- Total quantity of the product purchased
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, -- July 2017 data
    UNNEST(hits) AS hit, -- Expand hits
    UNNEST(hit.product) AS product -- Expand product within hits
  WHERE
    fullVisitorId IN (SELECT fullVisitorId FROM customers_with_product) -- Filter customers who purchased the target product
    AND product.v2ProductName != "YouTube Men's Vintage Henley" -- Exclude the target product
    AND product.productRevenue IS NOT NULL -- Only include transactions with revenue
  GROUP BY
    product.v2ProductName
)
SELECT
  other_purchased_products,
  quantity
FROM
  other_products_purchased
ORDER BY
  quantity DESC; -- Sort by quantity in descending order

-- Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.
-- Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level.

WITH product_metrics AS (
  SELECT
    FORMAT_DATE("%Y%m", PARSE_DATE("%Y%m%d", date)) AS month, -- Convert string date to DATE, then format to YYYYMM
    product.v2ProductName AS product_name, -- Product name
    COUNTIF(hit.eCommerceAction.action_type = "2") AS num_product_view, -- Product views (action_type = 2)
    COUNTIF(hit.eCommerceAction.action_type = "3") AS num_addtocart, -- Products added to cart (action_type = 3)
    COUNTIF(hit.eCommerceAction.action_type = "6" AND product.productRevenue IS NOT NULL) AS num_purchase -- Product purchases (action_type = 6 with non-null revenue)
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_2017*` -- Data from Jan-March 2017
  CROSS JOIN
    UNNEST(hits) AS hit -- Expand hits array
  CROSS JOIN
    UNNEST(hit.product) AS product -- Expand products in the hits array
  WHERE
    DATE(PARSE_DATE("%Y%m%d", date)) BETWEEN '2017-01-01' AND '2017-03-31' -- Filter by Jan-Mar 2017 dates (assuming 'date' is in string format)
  GROUP BY
    month, product_name
),
calculated_metrics AS (
  SELECT
    month,
    SUM(num_product_view) AS num_product_view, -- Total product views per month
    SUM(num_addtocart) AS num_addtocart, -- Total products added to cart per month
    SUM(num_purchase) AS num_purchase, -- Total product purchases per month
    SAFE_DIVIDE(SUM(num_addtocart), SUM(num_product_view)) * 100 AS add_to_cart_rate, -- Add-to-cart rate
    SAFE_DIVIDE(SUM(num_purchase), SUM(num_product_view)) * 100 AS purchase_rate -- Purchase rate
  FROM
    product_metrics
  GROUP BY
    month
)
SELECT
  month,
  num_product_view,
  num_addtocart,
  num_purchase,
  ROUND(add_to_cart_rate, 2) AS add_to_cart_rate, -- Round to 2 decimal points
  ROUND(purchase_rate, 2) AS purchase_rate -- Round to 2 decimal points
FROM
  calculated_metrics
ORDER BY
  month ASC; -- Sort by month 





