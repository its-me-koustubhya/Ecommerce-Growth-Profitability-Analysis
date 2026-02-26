-- Analysis 1: Monthly Revenue Trends [GROWTH]
-- Business Question: What is the revenue trend over time?
-- Monthly revenue, orders, and profit
-- This helps us understand:
-- Is revenue growing consistently?
-- Is growth seasonal?
-- Is AOV increasing?
-- Is margin stable?
SELECT 
    order_year,
    order_month,
    COUNT(order_id) AS total_orders,
    SUM(revenue) AS monthly_revenue,
    SUM(cogs) AS monthly_cogs,
    SUM(gross_profit) AS monthly_profit,
    AVG(revenue) AS avg_order_value,
    AVG(profit_margin) AS avg_profit_margin
FROM gold_fact_orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
-- KPIs: Monthly Revenue, Monthly Orders, Monthly Profit, Monthly AOV
-- Insights : Revenue growth is driven by:
-- Order volume increase
-- AOV increase

-- Question : Is this growth driven by more traffic OR better conversion?

-- Analysis 2: Monthly Session Trend 
-- This tells us:
-- Is traffic increasing?
-- Is growth driven by new users?
-- Is repeat traffic increasing?
-- Is retention improving?
SELECT 
    session_year,
    session_month,
    COUNT(website_session_id) AS total_sessions,
    SUM(CASE WHEN is_repeat_session = 1 THEN 1 ELSE 0 END) AS repeat_sessions,
    SUM(CASE WHEN is_repeat_session = 0 THEN 1 ELSE 0 END) AS new_sessions,
    CAST(SUM(CASE WHEN is_repeat_session = 1 THEN 1 ELSE 0 END) AS FLOAT)
        / COUNT(website_session_id) AS repeat_session_share
FROM gold_fact_sessions
GROUP BY session_year, session_month
ORDER BY session_year, session_month;
-- Revenue grew similarly, we can infer: Growth is primarily traffic-driven.But we must validate conversion rate next.
-- Repeat Sessions Are Increasing, That suggests:
-- Brand recognition improving
-- Retention improving
-- Possibly email or remarketing working
-- But we must quantify repeat %.
-- Strong Seasonality That likely indicates:
-- Holiday season (toys → highly seasonal)
-- Promotional campaigns

-- Analysis 3: Monthly Conversion Rate
-- This tells us:
-- Is conversion improving over time?
-- Is growth driven purely by traffic?
-- Did Q4 spikes improve conversion too?
-- Are we becoming more efficient at converting traffic?
SELECT 
    fs.session_year,
    fs.session_month,
    COUNT(DISTINCT fs.website_session_id) AS total_sessions,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    CAST(COUNT(DISTINCT fo.order_id) AS FLOAT)
        / COUNT(DISTINCT fs.website_session_id) AS conversion_rate
FROM gold_fact_sessions fs
LEFT JOIN gold_fact_orders fo
    ON fs.website_session_id = fo.website_session_id
GROUP BY fs.session_year, fs.session_month
ORDER BY fs.session_year, fs.session_month;
-- Conversion Rate Trend
-- 2012: ~2.6% – 5%
-- 2013: ~6% – 7%
-- 2014: ~6.5% – 7.9%
-- 2015: Touching ~8.6%
-- The company is not just scaling traffic — it is getting better at converting.
-- This is a sign of:
-- Better product-market fit
-- Better UX
-- Stronger brand trust
-- Better targeting of marketing campaigns
-- Increased repeat customers

-- November & December show consistent spikes.
-- This confirms:
-- Seasonality is real
-- Holiday buying intent increases conversion
-- Marketing in Q4 is highly effective

-- Revenue growth is driven by:
-- Traffic increase
-- Conversion rate improvement
-- Increasing AOV
-- This is healthy, scalable growth.

-- We now test two hypotheses:
-- 1️⃣ Is repeat traffic converting better?
-- 2️⃣ Is desktop outperforming mobile?

-- Analysis 4: Conversion by Device
-- This will tell us if:
-- Mobile UX is weak
-- Desktop drives revenue
-- Mobile traffic growth hides conversion issues
SELECT 
    fs.session_year,
    fs.session_month,
    fs.device_type,
    COUNT(DISTINCT fs.website_session_id) AS total_sessions,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    CAST(COUNT(DISTINCT fo.order_id) AS FLOAT)
        / COUNT(DISTINCT fs.website_session_id) AS conversion_rate
FROM gold_fact_sessions fs
LEFT JOIN gold_fact_orders fo
    ON fs.website_session_id = fo.website_session_id
GROUP BY 
    fs.session_year,
    fs.session_month,
    fs.device_type
ORDER BY 
    fs.session_year,
    fs.session_month,
    fs.device_type;
-- Desktop converts ~3x better than mobile.

-- Mobile Is Not Catching Up
-- This likely indicates:
-- Poor mobile UX
-- Checkout friction
-- Payment issues
-- Page load problems

-- Mobile is underperforming significantly.

-- Analysis 5: Conversion by New vs Repeat Users
-- This tells us if: Repeat users (loyal customers) are converting at higher rate.
SELECT 
    fs.session_year,
    fs.session_month,
    fs.is_repeat_session,
    COUNT(DISTINCT fs.website_session_id) AS total_sessions,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    CAST(COUNT(DISTINCT fo.order_id) AS FLOAT)
        / COUNT(DISTINCT fs.website_session_id) AS conversion_rate
FROM gold_fact_sessions fs
LEFT JOIN gold_fact_orders fo
    ON fs.website_session_id = fo.website_session_id
GROUP BY 
    fs.session_year,
    fs.session_month,
    fs.is_repeat_session
ORDER BY 
    fs.session_year,
    fs.session_month,
    fs.is_repeat_session;
-- Repeat Converts Better (Consistently)

-- Repeat Conversion Improving Over Time

-- Growth is driven by:
-- Traffic growth
-- Desktop strength
-- Repeat customer strength

-- Analysis 6: Revenue by New vs Repeat 
-- this will tell us:
-- Do repeat customers generate higher AOV?
-- Do they generate higher profit?
-- Is their revenue share increasing over time?
USE ToyStoreDB;

SELECT 
    fo.order_year,
    fo.order_month,
    fs.is_repeat_session,
    COUNT(fo.order_id) AS total_orders,
    SUM(fo.revenue) AS total_revenue,
    AVG(fo.revenue) AS avg_order_value,
    SUM(fo.gross_profit) AS total_profit
FROM gold_fact_orders fo
JOIN gold_fact_sessions fs
    ON fo.website_session_id = fs.website_session_id
GROUP BY 
    fo.order_year,
    fo.order_month,
    fs.is_repeat_session
ORDER BY 
    fo.order_year,
    fo.order_month,
    fs.is_repeat_session;
-- Repeat Revenue Share Is Increasing
-- Customers are coming back
-- Retention is improving
-- Brand equity is growing
-- LTV likely increasing
-- Growth is slowly shifting from pure acquisition → loyalty-supported growth.

-- Repeat Customers Do NOT Spend Much More Per Order
-- They convert more often,but they do not necessarily spend significantly more per order.
-- So growth from repeat is coming from:
-- ✔ Higher conversion rate
-- NOT
-- ✔ Higher basket size

-- Repeat profit is increasing proportionally with revenue.


-- FULL GROWTH DRIVER BREAKDOWN
-- Driver 1: Traffic Growth (Primary)
-- Sessions increased massively.

-- Driver 2: Conversion Improvement
-- From ~3% → ~8% overall.
-- Major performance gain.

-- Driver 3: Repeat Conversion Strength
-- Repeat converts ~1.5–2% higher.

-- Driver 4: AOV Expansion
-- From ~$50 → ~$63.
-- Clear price/mix upgrade.

-- Driver 5: Strong Q4 Seasonality
-- Holiday-driven spikes.

-- Hidden Risk We Identified
-- Mobile underperforms heavily.
-- Desktop is carrying conversion.
-- If mobile traffic increases in future:
-- Overall conversion may drop unless mobile UX improves.

-- Analysis 7: Product-Level Net Profitability
-- This tells us:
-- Which products truly drive profit
-- Which products look good on revenue but leak money
-- Whether refunds materially impact margins

WITH product_profit AS (
    SELECT 
        oi.product_id,
        COUNT(oi.order_item_id) AS total_units_sold,
        SUM(oi.price_usd) AS total_revenue,
        SUM(oi.cogs_usd) AS total_cogs,
        SUM(oi.item_profit) AS gross_profit
    FROM gold_fact_order_items oi
    GROUP BY oi.product_id
),
refund_data AS (
    SELECT 
        r.order_item_id,
        r.refund_amount_usd
    FROM gold_fact_refunds r
),
refund_by_product AS (
    SELECT 
        oi.product_id,
        SUM(ISNULL(r.refund_amount_usd, 0)) AS total_refund_amount
    FROM gold_fact_order_items oi
    LEFT JOIN refund_data r
        ON oi.order_item_id = r.order_item_id
    GROUP BY oi.product_id
)
SELECT 
    pp.product_id,
    dp.product_name,
    pp.total_units_sold,
    pp.total_revenue,
    pp.total_cogs,
    pp.gross_profit,
    rbp.total_refund_amount,
    (pp.gross_profit - rbp.total_refund_amount) AS net_profit,
    CASE 
        WHEN pp.total_revenue = 0 THEN 0
        ELSE rbp.total_refund_amount / pp.total_revenue
    END AS refund_rate,
    CASE 
        WHEN pp.total_revenue = 0 THEN 0
        ELSE (pp.gross_profit - rbp.total_refund_amount) / pp.total_revenue
    END AS net_profit_margin
FROM product_profit pp
JOIN refund_by_product rbp
    ON pp.product_id = rbp.product_id
JOIN gold_dim_products dp
    ON pp.product_id = dp.product_id
ORDER BY net_profit DESC;

-- The Original Mr. Fuzzy
-- This is the company’s flagship volume driver.
-- ✔ Massive revenue
-- ✔ Massive absolute profit
-- ⚠ Highest refund rate among top products

-- 5.1% refund rate is noticeably higher than others.
-- volume is so strong that it remains the most profitable SKU.
-- If refund rate is reduced even by 1–2%,
-- profit would increase significantly.
-- This product deserves operational attention.

-- The Forever Love Bear
-- Very healthy product.
-- ✔ Strong margin
-- ✔ Low refund
-- ✔ Clean profitability

-- This is a high-quality SKU.

-- The Birthday Sugar Panda
-- ⚠ Highest refund rate (6%)
-- But still strong net margin.

-- This may indicate:
-- High emotional purchase (birthday item)
-- Some dissatisfaction / damage issues
-- Worth investigating operationally.

-- Hudson River Mini Bear
-- most efficient SKU.
-- ✔ Lowest refund rate
-- ✔ Highest margin
-- ✔ Clean profitability

-- This product should likely be:
-- Promoted more
-- Used in bundles
-- Given marketing focus

-- Profit Concentration Risk
-- "Mr. Fuzzy" alone contributes huge portion of profit.
-- That means:
-- ⚠ Heavy dependence on one product.

-- If demand drops or refund issues worsen, profit could be hit hard.
-- Diversification matters.

-- Refunds Are Not Catastrophic

-- Refund rates range: 1% to 6%
-- That’s manageable.

-- Refund impact is noticeable, but not destroying margins.

-- So overall business health is strong.

-- Portfolio Classification

-- We can mentally classify:

-- Premium Efficient Product
-- Hudson River Mini Bear
-- High margin, low refund, strong efficiency

-- Volume Driver
-- Original Mr. Fuzzy
-- High revenue, medium refund, stable margin

-- Emotional / Risk SKU
-- Birthday Sugar Panda
-- High refund rate, but still profitable

-- Executive-Level Conclusion

-- The business:

-- ✔ Has strong margins (55–67%)
-- ✔ Maintains healthy net profitability
-- ✔ Has manageable refund leakage
-- ✔ Is driven by a few hero SKUs

-- But:

-- ⚠ Some products show elevated refund rates
-- ⚠ Profit concentration risk exists

-- QUESTION : Are high-refund products coming from specific traffic sources or devices?

-- Analysis 8: Refund Rate by Product & Device
-- For each product:
-- Is mobile refund rate higher?
-- Is desktop stable?
-- Is refund issue universal?
-- This tells us whether the problem is:
-- Product quality
-- Or device/UX related
WITH base_data AS (
    SELECT 
        oi.order_item_id,
        oi.product_id,
        fs.device_type,
        oi.price_usd
    FROM gold_fact_order_items oi
    JOIN gold_fact_orders fo
        ON oi.order_id = fo.order_id
    JOIN gold_fact_sessions fs
        ON fo.website_session_id = fs.website_session_id
),
refund_data AS (
    SELECT 
        order_item_id,
        refund_amount_usd
    FROM gold_fact_refunds
)
SELECT 
    bd.product_id,
    dp.product_name,
    bd.device_type,
    COUNT(bd.order_item_id) AS total_units,
    SUM(ISNULL(r.refund_amount_usd, 0)) AS total_refund_amount,
    COUNT(r.order_item_id) AS total_refund_count,
    CAST(COUNT(r.order_item_id) AS FLOAT) / COUNT(bd.order_item_id) AS refund_rate
FROM base_data bd
LEFT JOIN refund_data r
    ON bd.order_item_id = r.order_item_id
JOIN gold_dim_products dp
    ON bd.product_id = dp.product_id
GROUP BY 
    bd.product_id,
    dp.product_name,
    bd.device_type
ORDER BY refund_rate DESC;

-- Analysis 9: Refund Rate by Product × Traffic Source
-- Is refund rate higher for:
-- Paid traffic?
-- Certain campaigns?
-- Certain utm_sources?
-- This detects:
-- Low-quality acquisition.
WITH base_data AS (
    SELECT 
        oi.order_item_id,
        oi.product_id,
        fs.utm_source,
        oi.price_usd
    FROM gold_fact_order_items oi
    JOIN gold_fact_orders fo
        ON oi.order_id = fo.order_id
    JOIN gold_fact_sessions fs
        ON fo.website_session_id = fs.website_session_id
),
refund_data AS (
    SELECT 
        order_item_id,
        refund_amount_usd
    FROM gold_fact_refunds
)
SELECT 
    bd.product_id,
    dp.product_name,
    bd.utm_source,
    COUNT(bd.order_item_id) AS total_units,
    COUNT(r.order_item_id) AS total_refund_count,
    CAST(COUNT(r.order_item_id) AS FLOAT) / COUNT(bd.order_item_id) AS refund_rate
FROM base_data bd
LEFT JOIN refund_data r
    ON bd.order_item_id = r.order_item_id
JOIN gold_dim_products dp
    ON bd.product_id = dp.product_id
GROUP BY 
    bd.product_id,
    dp.product_name,
    bd.utm_source
ORDER BY refund_rate DESC;

-- PART 1 — Refund Rate by Product × Device
-- Key Observations
-- The Birthday Sugar Panda

-- Desktop refund rate: 6.2%
-- Mobile refund rate: 4.9%
-- Refund issue is stronger on desktop.

-- This is important:
-- Earlier mobile had poor conversion.
-- But refund problem here is NOT mobile-driven.

-- Likely:
-- Product expectation mismatch
-- Quality issue
-- Description clarity issue

-- The Original Mr. Fuzzy
-- Mobile refund rate: 5.6%
-- Desktop refund rate: 5.0%
-- Very similar across devices.

-- That suggests:
-- Refund issue is product-intrinsic, not UX-driven.

-- The Forever Love Bear
-- ~2.2% both devices
-- Very stable, clean SKU.

-- Hudson River Mini Bear
-- Desktop: 1.25%
-- Mobile: 1.37%
-- Extremely healthy product.

-- Device-Level Conclusion
-- Refund problems are NOT primarily mobile-related.
-- Earlier:
-- Mobile had weak conversion.
-- But refund leakage:
-- Is product-driven, not device-driven.

-- That’s an important separation.

-- PART 2 — Refund Rate by Product × Traffic Source

-- Now this is very interesting.
-- The Birthday Sugar Panda

-- Refund rates:
-- NULL (direct/unknown): 6.47%
-- gsearch: 6.24%
-- bsearch: 4.82%
-- socialbook: 2.38%

-- Insight:
-- Refund rate is highest from:
-- Direct traffic
-- Google search

-- Lowest from:
-- Socialbook

-- This suggests:
-- Paid search traffic might be:
-- Less aligned with product expectations
-- Attracting lower-intent buyers
-- Social traffic appears higher quality for this SKU.

-- Simulation 1: Profit Gain if Refund Rate Drops by 1%
WITH product_stats AS (
    SELECT 
        oi.product_id,
        dp.product_name,
        COUNT(oi.order_item_id) AS total_units,
        SUM(oi.price_usd) AS total_revenue,
        SUM(oi.item_profit) AS gross_profit,
        SUM(ISNULL(r.refund_amount_usd, 0)) AS total_refund_amount
    FROM gold_fact_order_items oi
    LEFT JOIN gold_fact_refunds r
        ON oi.order_item_id = r.order_item_id
    JOIN gold_dim_products dp
        ON oi.product_id = dp.product_id
    GROUP BY oi.product_id, dp.product_name
)
SELECT 
    product_id,
    product_name,
    total_units,
    total_revenue,
    gross_profit,
    total_refund_amount,
    -- Current refund rate
    total_refund_amount / total_revenue AS current_refund_rate,
    
    -- Simulated 1% refund reduction impact
    (0.01 * total_units) * (gross_profit / total_units) 
        AS estimated_profit_gain_if_1pct_reduction
FROM product_stats
ORDER BY estimated_profit_gain_if_1pct_reduction DESC;


-- Simulation 2: What if repeat customer share increases by 5%?
WITH conversion_data AS (
    SELECT 
        fs.is_repeat_session,
        COUNT(DISTINCT fs.website_session_id) AS total_sessions,
        COUNT(DISTINCT fo.order_id) AS total_orders
    FROM gold_fact_sessions fs
    LEFT JOIN gold_fact_orders fo
        ON fs.website_session_id = fo.website_session_id
    GROUP BY fs.is_repeat_session
)
SELECT 
    is_repeat_session,
    total_sessions,
    total_orders,
    CAST(total_orders AS FLOAT) / total_sessions AS conversion_rate
FROM conversion_data;