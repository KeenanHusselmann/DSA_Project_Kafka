//Configuration code for kafka consumer 

import ballerina/log;
import ballerinax/kafka;

//This code section defines an isolated class , DeliveryStreamGenerator 
//that is responsible for generating a stream of delivery records from a Kafka topic.

isolated class DeliveryStreamGenerator {
    private final string consumerGroup; // a string representing the consumer group ID
    private final DeliveryService delivery; //object representing the delivery service
    private final kafka:Consumer consumer; // object representing the Kafka consumer

    //kafka consumer configuration and init function()
    isolated function init(string consumerGroup, DeliveryService delivery) returns error? {
        self.consumerGroup = consumerGroup;
        self.delivery = delivery;
        kafka:ConsumerConfiguration consumerConfiguration = { //creating a new Kafka consumer using the kafka:ConsumerConfiguration object
            // The configuration specifies the consumer group ID, offset reset policy, 
            //topics to subscribe to, and maximum number of records to poll.

            groupId: consumerGroup, //specifies the consumer group ID,

            offsetReset: kafka:OFFSET_RESET_EARLIEST, //determines the offset reset policy, 
            //which means the consumer will start consuming from the earliest available offset (the beginning of the topic).

            topics: delivery, //specifies the topics that the consumer should subscribe to.
            //a DeliveryService object representing the delivery service. In this case,
            //the delivery object contains the topic names to subscribe to.(standard,express,international)

            maxPollRecords: 100 //specifies the maximum number of records to poll from the Kafka broker in a single call.
            //100 is the value assigned to the maxPollRecords property, 
            //which means the consumer will poll at most 100 records from the broker in a single call.
        };
        //self.consumer holds the instance of the Kafka consumer.
        self.consumer = check new (kafka:DEFAULT_URL, consumerConfiguration); //creates a new instance of a Kafka consumer using the kafka:Consumer class
    }
//next() Function implemented
    public isolated function next() returns record {|Delivery value;|}? {
        //The next function is public isolated function that returns a record containing a Delivery value. 
        //It uses a while loop to continuously poll the Kafka consumer for new records.
        while true {
            DeliveryRecord[]|error deliveryRecords = self.consumer->pollPayload(20); //using kafka consumer to pull records from kafka server autonomously
            //Polling: The function calls self.consumer->pollPayload(20) to poll the Kafka consumer for new records. 
            //The 20 parameter specifies the timeout in milliseconds.

            if deliveryRecords is error {
                // If the polling operation returns an error, the function logs an error message and returns.
                log:printError("Failed to retrieve data from the Kafka server", deliveryRecords, id = self.consumerGroup);
                return;
            }
            if deliveryRecords.length() < 1 {
                //If no records are available, the function logs an info message and continues to the next iteration.
                log:printInfo(string `No delivery service available in "${self.delivery}"`, id = self.consumerGroup);
                continue;
            }
            // If records are available, the function returns a record containing the first record in the deliveryRecords array.
            return {value: new (deliveryRecords[0])};

            
        }
    }
}

//Take Away
//This configuration is used to create a Kafka consumer that can be used to generate a stream of delivery records from a Kafka topic.
//a function to consume records from a Kafka topic.

// The DeliveryStreamGenerator class is designed to generate a stream of delivery records from a Kafka topic.

// The init function initializes the class with a consumer group ID, delivery service, and Kafka consumer configuration.

// The next function is designed to continuously poll the Kafka consumer for new records and return them as they become available.
