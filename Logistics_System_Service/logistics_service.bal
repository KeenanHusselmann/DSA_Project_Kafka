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
