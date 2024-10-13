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
