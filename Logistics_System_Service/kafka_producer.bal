import ballerinax/kafka;

//This code creates a Kafka producer and defines a function to send a DeliveryRecord object to a Kafka topic.
// The topic is determined based on the shipmentId in the deliveryRecord.

# kafka producer configuration
final kafka:Producer deliveryProducer = check new (kafka:DEFAULT_URL); //creates a new Kafka producer instance

//The check keyword is used to handle errors, and new is used to create a new instance of the kafka:Producer class. 
//The kafka:DEFAULT_URL is likely a default URL for the Kafka broker.

isolated function deliveryServiceUpdate(DeliveryRecord deliveryRecord) returns error? {
    lock { //used to ensure thread safety

        check deliveryProducer->send({ //the code sends a message to a Kafka topic using the deliveryProducer
            topic: shipmentTable.get(deliveryRecord.shipmentId).delivery,
            //The topic is determined by looking up the shipmentId in a shipmentTable
            // and retrieving the corresponding delivery topic.

            value: deliveryRecord // The deliveryRecord object is sent as the value of the message.

        });
    }
}

//Take Away
//This program code creates a Kafka producer and defines a function to send a DeliveryRecord object to a Kafka topic based on the shipmentId.  
//The topic is determined based on the shipmentId in the deliveryRecord.

//The function ensures thread safety using lock and handles errors using check.
//The send method takes a record with two fields:
//topic: This is the Kafka topic to which the message will be sent. 
//The topic is retrieved from a shipmentTable using the shipmentId from the deliveryRecord.
//value: This is the value of the message being sent, which is the deliveryRecord object itself.
