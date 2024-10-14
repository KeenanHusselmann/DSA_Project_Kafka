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

//Add code here 
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
}