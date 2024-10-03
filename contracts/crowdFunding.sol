// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Crowdfunding {

    struct Campaign {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
    }

    Campaign[] public campaigns;

// End Campaign:

// Once the deadline of a campaign is reached, the smart contract should automatically transfer the funds raised to the benefactor.
// The contract should not allow any more donations after the campaign ends.
// If the amountRaised is less than the goal, the contract should still transfer the funds to the benefactor.

    // ******************
    // EVENTS SECTIONS
    // ******************
    event campaignCreated(string title, string description, address benefactor, uint goal, uint deadline, uint amountRaised);
    event donationReceived(string title, uint donation);

    // *****************************
    // INTERNAL FUNCTION SECTIONS
    // *****************************
    function getCampaignIndex(string memory _title) internal view returns(uint) {
        for (uint i = 0; i < campaigns.length; i++) {
            if (keccak256(abi.encodePacked(campaigns[i].title)) == keccak256(abi.encodePacked(_title))) {
                return i;
            }
        }
        revert("Campaign does not exist!!");
    }

    function confirmValidator(uint _index) internal view {
        require(campaigns[_index].benefactor == msg.sender, "You do not have the admin right to execute this transaction");
    }

    function autoEndCampaign() internal {
        
    }

    // *********************
    // MODIFIERS SECTIONS
    // *********************
    modifier validateCampaign(string memory _title) {
        bool exists = false;
        for (uint i = 0; i < campaigns.length; i++) {
            if (keccak256(abi.encodePacked(campaigns[i].title)) == keccak256(abi.encodePacked(_title))) {
                exists = true;
                break;
            }
        }
        require(exists, "Campaign does not exist!!");
        _;
    }

    // ******************
    // CLIENT FUNCTIONS
    // ******************
    function createCampaign(string memory _title, string memory _description, address payable _benefactor, uint _goal, uint _durationHours) public {
        uint _deadline = block.timestamp + (_durationHours*60*60);
        Campaign memory newCampaign = Campaign({title: _title, description:_description, benefactor:_benefactor, goal:_goal, deadline:_deadline, amountRaised: 0});

        campaigns.push(newCampaign);
        emit campaignCreated(_title, _description, _benefactor, _goal, _deadline, 0);
    }

    function donateToCampaign(string memory _title) payable public validateCampaign(_title) {
        uint index = getCampaignIndex(_title);
        campaigns[index].amountRaised += msg.value;
        emit donationReceived(_title, msg.value);
    }

    function endCampaign(string memory _title) public payable validateCampaign(_title) returns(string memory) {
        uint index = getCampaignIndex(_title);
        confirmValidator(index);
        return campaigns[index].title;
    }


}