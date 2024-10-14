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
