# Containerized Microservices with Ballerina and Kafka
## Description
#### In this project, we are working on part of a larger logistics system. This system handles requests for package delivery from multiple providers, offering specialized services for different types of shipments, such as standard delivery, express delivery, and international delivery. The focus is on situations where customers need to schedule a package pickup and delivery service.
#### Here’s how it works:
##### 1.
#### When a customer wants to send a package, they submit a request to the central logistics service through Kafka as a middleware. This request includes details such as the type of shipment (standard, express, international), pickup location, delivery location, preferred  time slots, and customer information (first name, last name, contact number).
##### 2.
#### The logistics service processes the request and communicates with various delivery services (standard, express, international) to find the best available time for the pickup and delivery based on the customer’s preferences. These delivery services may need to ### ### coordinate to determine the optimal route and schedule, especially for international deliveries.
##### 3.
#### Once the pickup and delivery times are confirmed, the logistics service sends the complete details back to the customer, including tracking information and estimated delivery time.
![containerizedMicroservices](https://github.com/user-attachments/assets/87aff4ed-0cef-4903-a1eb-e5c811d7eef5)
#
![Starting akfka and zookeeper using docker](https://github.com/user-attachments/assets/b9476c28-5bbd-4041-9c78-b5987db5c2e3)
#
![docker image build using bal build --cloud-docker](https://github.com/user-attachments/assets/fbce564d-d1d6-4696-a34c-edcf4e47449d)
