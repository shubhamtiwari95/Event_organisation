//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract eventOrganisation {
    struct Event {
        address organiser;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) public {
        require(date>block.timestamp, "You can organise event for future date");
        require(ticketCount>0, "You can organise event only if you create more than 0 tickets");

        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount);
        nextId++;
    }

    function buyTicket (uint id, uint quantity) external payable {
        require(events[id].date!=0, "This event does not exist");
        require(block.timestamp<events[id].date, "Event has already over");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity, "Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;    
    }

    function transferTickets(uint id, uint quantity, address to) external {
        require(events[id].date!=0, "This event does not exist");
        require(block.timestamp<events[id].date, "Event has already over");
        require(tickets[msg.sender][id]>=quantity, "You do not have enough tickets");
        tickets[msg.sender][id]=quantity;
        tickets[to][id]+=quantity; 

    }
}