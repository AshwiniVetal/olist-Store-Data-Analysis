CREATE DATABASE olist_kpi ;
use olist_kpi ;
select*from olist_customers_dataset;
-- 1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics.
select kpi1.day_end,round((kpi1.total_pmt/(select sum(payment_value) from 
olist_order_payments_dataset_NEW))*100,2) AS perc_pmtvalue
from 
(select ord.day_end,sum(pmt.payment_value) as total_pmt
from olist_order_payments_dataset_NEW as pmt join 
(select distinct(order_id),case when weekday(order_purchase_timestamp) in (5,6) then "weekend"
else "weekday" end as day_end from olist_orders_dataset_NEW) as ord on order_id = pmT.order_id group by day_end) 
as kpi1;
SELECT 
    kpi1.day_end,
    ROUND((kpi1.total_pmt / (SELECT SUM(payment_value) FROM olist_order_payments_dataset_NEW)) * 100, 2) AS perc_pmtvalue
FROM
    (SELECT 
        ord.day_end,
            SUM(pmt.payment_value) AS total_pmt
    FROM
        olist_order_payments_dataset_NEW AS pmt
    JOIN (SELECT 
        DISTINCT(order_id),
            CASE
                WHEN WEEKDAY(order_purchase_timestamp) IN (5 , 6) THEN 'weekend'
                ELSE 'weekday'
            END AS day_end
    FROM
        olist_orders_dataset_NEW) AS ord ON pmt.order_id = ord.order_id
    GROUP BY day_end) AS kpi1
LIMIT 0 , 1000;
SELECT 
    kpi1.day_end,
    ROUND((kpi1.total_pmt / (SELECT SUM(payment_value) FROM olist_order_payments_dataset_NEW)) * 100, 2) AS perc_pmtvalue,
    ROUND((kpi1.total_weekend_pmt / (SELECT SUM(payment_value) FROM olist_order_payments_dataset_NEW WHERE WEEKDAY(order_purchase_timestamp) IN (5, 6))) * 100, 2) AS perc_weekend_pmtvalue
FROM
    (SELECT 
        ord.day_end,
            SUM(pmt.payment_value) AS total_pmt,
            SUM(CASE WHEN ord.day_end = 'weekend' THEN pmt.payment_value ELSE 0 END) AS total_weekend_pmt
    FROM
        olist_order_payments_dataset_NEW AS pmt
    JOIN (SELECT 
        DISTINCT(order_id),
            CASE
                WHEN WEEKDAY(order_purchase_timestamp) IN (5 , 6) THEN 'weekend'
                ELSE 'weekday'
            END AS day_end
    FROM
        olist_orders_dataset_NEW) AS ord ON pmt.order_id = ord.order_id
    GROUP BY day_end) AS kpi1
LIMIT 0 , 1000;
