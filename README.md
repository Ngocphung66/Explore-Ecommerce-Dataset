# [SQl] Explore-Ecommerce-Dataset
## I.Introduction
This project contains an eCommerce dataset that I will explore using SQL on [Google BigQuery](https://cloud.google.com/bigquery?hl=en). The dataset is based on the Google Analytics public dataset and contains data from an eCommerce website.
## II. Requirements
* [Google Cloud Platform account](https://cloud.google.com/?hl=en)
* Project on Google Cloud Platform
* [Google BigQuery API enabled](https://cloud.google.com/bigquery/docs/enable-transfer-service#:~:text=Enable%20the%20BigQuery%20Data%20Transfer%20Service,-Before%20you%20can&text=Open%20the%20BigQuery%20Data%20Transfer,Click%20the%20ENABLE%20button)
* [SQL query editor or IDE](https://cloud.google.com/monitoring/mql/query-editor)
## III. Dataset Access
The eCommerce dataset is stored in a public Google BigQuery dataset. To access the dataset, follow these steps:
* Log in to your Google Cloud Platform account and create a new project.
* Navigate to the BigQuery console and select your newly created project.
* In the navigation panel, select "Add Data" and then "Search a project".
* Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions" and click "Enter".
* Click on the "ga_sessions_" table to open it.
## IV. Exploring the Dataset
In this project, I will write 08 query in Bigquery base on Google Analytics dataset

**Query 01: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)**
* SQL code

![image](https://github.com/user-attachments/assets/09f92e30-f0c1-495b-998b-00004a2ec25f)
* Query results

![image](https://github.com/user-attachments/assets/6bfb5eea-55dd-443d-bb06-c1afcc2ad688)

**Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)**
* SQL code

![image](https://github.com/user-attachments/assets/fe062746-752d-47af-a425-c186417a0a1c)
* Query results

![image](https://github.com/user-attachments/assets/f34065ff-5a56-478e-b661-5c129a23a8e3)

**Query 03: Revenue by traffic source by week, by month in June 2017**
* SQL code

![image](https://github.com/user-attachments/assets/a8f87350-26ac-4ae5-88cb-cb852181eb97)
![image](https://github.com/user-attachments/assets/d9786a2f-0fee-487f-8a82-97ab6f53d7f2)
* Query results

![image](https://github.com/user-attachments/assets/cd134a84-94ab-4812-bbd7-43789de69aca)
![image](https://github.com/user-attachments/assets/babc8328-d3ba-4262-b9cd-d3c8a4c81ce5)

**Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in 2017** 
* SQL code

![image](https://github.com/user-attachments/assets/dd5b0b80-4c80-4a68-8ce2-d6c212c287ac)
![image](https://github.com/user-attachments/assets/6cc764f7-0a05-453d-933b-7150ee3f096a)
* Query results

![image](https://github.com/user-attachments/assets/ed2a5714-d3dd-460d-b739-f4539755c2fa)

**Query 05: Average number of transactions per user that made a purchase in July 2017**
* SQL code

![image](https://github.com/user-attachments/assets/939712e9-5d9a-4b7e-b01c-77aab7057574)
* Query results

![image](https://github.com/user-attachments/assets/82950d72-0211-4b8b-8345-9957e248b0bc)

**Query 06: Average amount of money spent per session. Only include purchaser data in July 2017**
* SQL code

![image](https://github.com/user-attachments/assets/674adaa7-70fd-43e9-9dff-9c61f5cfc2a0)
* Query results

![image](https://github.com/user-attachments/assets/51d47ea1-105e-433e-8283-48ab5b2adce7)

**Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.**

* SQL code
  
![image](https://github.com/user-attachments/assets/bbdddd6b-09a5-4c13-b814-2f65b7355653)
* Query results
  
![image](https://github.com/user-attachments/assets/a53eecdf-827f-4e4c-87a7-64bc451822d7)

**Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.**

Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level.
* SQL code
![image](https://github.com/user-attachments/assets/dc3d86af-5875-44d9-9259-9c8c566532f9)
* Query results
![image](https://github.com/user-attachments/assets/f13b715e-36b6-46cf-84c6-515c5a808106)

## V. Conclusion
* In conclusion, my exploration of the eCommerce dataset using SQL on Google BigQuery based on the Google Analytics dataset has revealed several interesting insights.
* By exploring eCommerce dataset, I have gained valuable information about total visits, pageview, transactions, bounce rate, and revenue per traffic source,.... which could inform future business decisions.
* To deep dive into the insights and key trends, the next step will visualize the data with some software like Power BI, Tableau,...
* Overall, this project has demonstrated the power of using SQL and big data tools like Google BigQuery to gain insights into large datasets.





