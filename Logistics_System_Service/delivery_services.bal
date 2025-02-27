import ballerina/graphql; //for creating GraphQL services and handling GraphQL queries.
import ballerina/uuid; // for generating unique identifiers.

//GraphQl  configuration 
//This configuration enables GraphiQL,a graphical interface for testing and exploring GraphQL APIs.
@graphql:ServiceConfig {
    // used to configure the GraphQL service
    graphiql: {
        enabled: true
    }
}

service /delivery on new graphql:Listener(9090) {
    //used to define a new GraphQL service
    //The GraphQL service is exposed on port 9090 and is accessible at the "/delivery" endpoint.

    //get customersresource function implemented
        //function returns a read-only array of Customer objects.
    isolated  resource function get customers() returns readonly & Customer[] {

        lock {
            //The lock statement is used to ensure thread safety when accessing the customerTable.
            return  customerTable.toArray().cloneReadOnly();
        }
    }

    isolated resource function get shipments() returns readonly & Shipment[]|error {
        //function returns a read-only array of Shipment objects.
        lock {
            return shipmentTable.toArray().cloneReadOnly();
        }
    }

    // registerCustomer remote function implemented
    isolated remote function registerCustomer(NewCustomer newCustomer) returns Customer {
        //function registers a new customer and returns the newly created Customer object.
        Customer customer = {
            id: uuid:createType1AsString(),
            //function is used to generate a unique identifier for the customer.
            ...newCustomer
            //used to merge the properties of the newCustomer object into the customer object.
        };
        lock {
            //adds the customer to the customerTable using a lock statement to ensure thread safety.
            customerTable.put(customer);
        }
        return customer; //returns the newly created customer object

    }

        isolated remote function registerShipment(NewShipment newShipment) returns Shipment {
        // function registers a new shipment and returns the created shipment object
        Shipment shipment = {
            id: uuid:createType1AsString(),
            ...newShipment
            //creates a new Shipment object with a generated UUID as the id 
            //and merges the input newShipment object into it.

        };
        lock { // lock statement ensures that the shipment is added to the shipmentTable atomically.

            shipmentTable.put(shipment);
            //adds the shipment to the shipmentTable using a lock statement to ensure thread safety.
        }
        return shipment; //function returns the created Shipment object.
    }


    //delivery remote function
    isolated remote function deliver(DeliveryUpdate deliveryUpdate) returns DeliveryRecord|error {
        //function updates the delivery status of a shipment and returns a DeliveryRecord object or an error.
        lock {
            if !shipmentTable.hasKey(deliveryUpdate.shipmentId) {
                //checks if the shipment with the given shipmentId exists in the shipmentTable.
                // If not, it returns an error.
                return error("Shipment not found!");
            }
        }
        //creates a new DeliveryRecord object with a generated UUID as the id
        // and merges the input deliveryUpdate object into it.
        DeliveryRecord deliveryRecord = {
            id: uuid:createType1AsString(),
            ...deliveryUpdate
        };
        check deliveryServiceUpdate(deliveryRecord);
        //calls the deliveryServiceUpdate function to update the delivery service.
        return deliveryRecord; // returns the created DeliveryRecord object.
    }

    //subscribe delivery resource function implemented
    isolated resource function subscribe delivery(string shipmentId, DeliveryService delivery) returns stream<Delivery>|error {
        //subscribe delivery function enables real-time delivery tracking through a stream.
        //function subscribes to a delivery stream for a given customer and returns a stream of Delivery objects or an error.

        DeliveryStreamGenerator deliveryStreamGenerator = check new (shipmentId, delivery);
        //creates a new DeliveryStreamGenerator object with the given shipmentId and delivery service.

        stream<Delivery> deliveryStream = new (deliveryStreamGenerator);
        //creates a new stream of Delivery objects using the DeliveryStreamGenerator
        return deliveryStream; //returns the created stream of Delivery objects or an error.
    }
}
