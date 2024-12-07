// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Enrollment.sol";

contract TestEnrollment {
    Enrollment conferenceEnroll;

    function beforeEach() public {
        conferenceEnroll = new Enrollment();
    }

    function testSignUp() public {
        conferenceEnroll.signUp("Alice");
        Assert.equal(conferenceEnroll.getParticipantName(address(this)), "Alice", "Alice failed to sign up.");
        Assert.equal(conferenceEnroll.getParticipantConfList(address(this)).length, 0, "Alice should have no conference.");
    }

    // Test the delegate functionality
    function testDelegate() public {
        string memory participantName = "Alice";
        address delegateAddress = address(0x1);

        conferenceEnroll.signUp(participantName);
        conferenceEnroll.delegate(delegateAddress);
        // Check if address(0x1) is a trustee of the current sender (this address)
        bool isTrustee = conferenceEnroll.isTrustee(delegateAddress, address(this));
        Assert.equal(isTrustee, true, "Address 0x1 should be a trustee of the sender");
    }

    function testEnroll() public {
        string memory participantName = "Alice";
        string memory conferenceName = "Blockchain Conference 2024";
        uint maxPerson = 10;

        conferenceEnroll.signUp(participantName);
        conferenceEnroll.newConference(conferenceName, "" , maxPerson);
        // uint conferenceId = 0; // Conference ID starts from 0
        conferenceEnroll.enroll(conferenceName);

        // Check if Alice is enrolled in the conference
        string[] memory myConferences = conferenceEnroll.queryMyConf();
        Assert.equal(myConferences.length, 1, "Alice should be enrolled in 1 conference.");
        Assert.equal(myConferences[0], conferenceName, "Alice should be enrolled in Blockchain Conference.");
    }

    // function testEnrollFor() public {
    //     string memory participantName1 = "Alice";
    //     string memory participantName2 = "Bob";
    //     string memory conferenceName = "Blockchain Conference 2024";
    //     uint maxPerson = 10;

    //     // Alice and Bob sign up
    //     conferenceEnroll.signUp(participantName1);
    //     conferenceEnroll.signUp(participantName2);

    //     // Administrator creates a new conference
    //     conferenceEnroll.newConference(conferenceName, maxPerson);

    //     // Alice delegates to Bob
    //     conferenceEnroll.delegate(address(0x1));

    //     // Bob enrolls Alice in the conference
    //     uint conferenceId = 0; // Conference ID starts from 0
    //     conferenceEnroll.enrollFor(address(0x1), conferenceId);

    //     // Check if Alice is enrolled in the conference
    //     string[] memory myConferences = conferenceEnroll.queryMyConf();
    //     Assert.equal(myConferences.length, 1, "Alice should be enrolled in 1 conference.");
    //     Assert.equal(myConferences[0], conferenceName, "Alice should be enrolled in Blockchain Conference.");
    // }

    // function testConferenceExpiration() public {
    //     string memory participantName = "Alice";
    //     string memory conferenceName = "Blockchain Conference";
    //     uint maxPerson = 2;

    //     // Alice signs up
    //     conferenceEnroll.signUp(participantName);

    //     // Administrator creates a new conference
    //     conferenceEnroll.newConference(conferenceName, maxPerson);

    //     // Alice enrolls in the conference
    //     uint conferenceId = 0;
    //     conferenceEnroll.enroll(conferenceId);

    //     // Now there is 1 person enrolled, let's enroll another person
    //     string memory participantName2 = "Bob";
    //     conferenceEnroll.signUp(participantName2);
    //     conferenceEnroll.enroll(conferenceId);

    //     // Check that the conference is closed for registration
    //     Conference[] memory openConfs = conferenceEnroll.queryConfList();
    //     Assert.equal(openConfs.length, 0, "The conference should be closed for registration.");
    // }

    // Test the conference creation and destruction by the administrator
    // function testAdminFunctions() public {
    //     address admin = conferenceEnroll.administrator();

    //     // Check that the administrator address is correct
    //     Assert.equal(admin, address(this), "The administrator should be the sender of the contract.");
        
    //     // Administrator can create a new conference
    //     string memory conferenceName = "New Conference";
    //     uint maxPerson = 100;
    //     conferenceEnroll.newConference(conferenceName, maxPerson);
        
    //     // Check if the conference has been created
    //     Conference[] memory conferences = conferenceEnroll.queryConfList();
    //     Assert.equal(conferences.length, 1, "There should be 1 open conference.");
    // }

    // function testDestruct() public payable {
    //     conferenceEnroll.destruct{value: 1 ether}();
    //     uint balance = address(conferenceEnroll).balance;
    //     Assert.equal(balance, 0, "Contract balance should be 0 after destruction");
    // }
}