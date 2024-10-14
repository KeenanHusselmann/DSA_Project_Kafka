//The use of readonly records and immutable data structures shows a focus on thread safety and data integrity.
//defining record types
type Customer readonly & record {|
    readonly string id;
    *NewCustomer;
|};

type NewCustomer record {|
    string firstName;
    string lastName;
    int age;
    string location;
    string email;
    string mobile;

|};

type Shipment readonly & record {|
    readonly string id;
    *NewShipment;
|};

type NewShipment record {|
    string shipmentType;
    string pickupLocation;
    string deliveryLocation;
    string preferredTimeSlot;
    DeliveryService delivery;
|};

//defining immutable tables
//Once data is added, it cannot be modified or removed. This ensures data integrity and consistency.
//they can be accessed by multiple processes or threads without the risk of data corruption or race conditions.

isolated table<Customer> key(id) customerTable = table [];
isolated table<Shipment> key(id) shipmentTable = table [];
//service class implemented
service class Delivery {

    //This class is designed to handle delivery records 
    //The Delivery class defines several resource functions that allow access to specific properties of the deliveryRecord
    private final DeliveryRecord deliveryRecord;

    isolated function init(DeliveryRecord deliveryRecord) {
        // an isolated function that initializes the class with a DeliveryRecord instance.
        self.deliveryRecord = deliveryRecord;
        //initializes a new delivery record
        //self.deliveryRecord variable is assigned the passed deliveryRecord parameter.
    }
}
