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

enum DeliveryService {
    //an enumeration type that defines three possible delivery services: standard_delivery, express_delivery, and international_delivery.
    //The use of an enumeration type for DeliveryService provides a clear  and explicit way to define the possible delivery services.

    standard_delivery,
    express_delivery,
    international_delivery
};

type DeliveryUpdate record {|
    string shipmentType;
    string deliveryLocation;
    string shipmentId;
|};

type DeliveryRecord readonly & record {|
    readonly string id;
    *DeliveryUpdate;
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

    //The use of isolated ensures that each resource function operates independently, promoting safe concurrent access.
    isolated resource function get id() returns string => self.deliveryRecord.id;

    //this function returns the id property of the deliveryRecord

    isolated resource function get shipmentType() returns string => self.deliveryRecord.shipmentType;

    //This function returns the shipmentType property, indicating the type of shipment (e.g., standard, express).

    isolated resource function get deliveryLocation() returns string => self.deliveryRecord.deliveryLocation;

    //This function returns the deliveryLocation, which specifies where the delivery is to be made.
    isolated resource function get shipment() returns Shipment {
        //this function retrieves the Shipment associated with the delivery.
        //It uses a lock block to ensure thread safety when accessing the shipmentTable
        lock {
            return shipmentTable.get(self.deliveryRecord.shipmentId);
            // retrieves the shipment using the shipmentId from the deliveryRecord.
        }
    }
}
