// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
pragma experimental ABIEncoderV2;

contract Enrollment{
    address public administrator;
    struct Participant{
        string name;
        string[] conferences; // index of conferences, start from 0.
    }
    struct Conference{
        string name;
        string detail;
        uint maxPerson;
        uint curPerson;
        bool canRegister;
    }
    // 参与者地址到信息的映射
    mapping(address=>Participant) participants;
    // 会议信息列表
    Conference[] public conferences;
    // 受托方地址与委托方信息的映射
    mapping(address=>Participant[]) trustees;

    event ConferenceExpire(string _name);
    event NewConference(string _name);
    event MyNewConference(address participant, string confName);
    

    modifier onlyAdministrator(){
        require(msg.sender == administrator, "Only administraotr can call this function.");
        _;
    }

    constructor() {
        administrator = msg.sender;
    }

    function signUp(string memory _name) public {
        require(bytes(participants[msg.sender].name).length == 0, "Already signed up.");
        participants[msg.sender] = Participant({ name: _name, conferences: new string[](0)});
    }

    function enroll(string memory _conferenceName) public {
        bool found = false; // 用于标记是否找到会议
        uint conferenceIndex = 0;
        // 遍历 conferences 数组查找匹配的会议名称
        for (uint i = 0; i < conferences.length; i++) {
            if (keccak256(bytes(conferences[i].name)) == keccak256(bytes(_conferenceName))) {
                found = true;
                conferenceIndex = i; // 记录找到的会议索引
                break;
            }
        }
        require(bytes(participants[msg.sender].name).length > 0, "You need to sign up first.");
        require(found, "Conference not found.");
        Conference storage conf = conferences[conferenceIndex];
        require(conf.canRegister, "Conference registration is closed.");
        require(conf.curPerson < conf.maxPerson, "Conference is full.");
        conf.curPerson++;
        participants[msg.sender].conferences.push(conf.name);
        emit MyNewConference(msg.sender, conf.name);

        if (conf.curPerson >= conf.maxPerson) {
            conf.canRegister = false;
            emit ConferenceExpire(conf.name);
        }
    }

    function isTrustee(address _trustee, address _delegator) public view returns(bool){
        Participant[] memory delegators = trustees[_trustee];
        for(uint i = 0;i<delegators.length; i++){
            if(keccak256(bytes(delegators[i].name)) == keccak256(bytes(participants[_delegator].name))){
                return true;
            }
        }
        return false;
    }

    function delegate(address _to) public {
        require(bytes(participants[msg.sender].name).length > 0, "You need to sign up first.");
        require(_to != address(0), "Invalid delegate address.");
        trustees[_to].push(participants[msg.sender]);
    }

    // delegator: enroll for who
    function enrollFor(address _delegator, string memory _conferenceName) public {
        require(bytes(participants[msg.sender].name).length > 0, "You need to sign up first.");
        require(isTrustee(msg.sender, _delegator), "You are not authorized for this user.");

        bool conferenceExists = false;
        uint conferenceId = 0;
        for (uint i = 0; i < conferences.length; i++) {
            if (keccak256(bytes(conferences[i].name)) == keccak256(bytes(_conferenceName))) {
                conferenceExists = true;
                conferenceId = i;
                break;
            }
        }
        require(conferenceExists, "Conference not found.");

        Conference storage conf = conferences[conferenceId];
        require(conf.canRegister, "Conference registration is closed.");
        require(conf.curPerson < conf.maxPerson, "Conference is full.");

        conf.curPerson++;

        // TODO: _delegator may haven't sign up and have no name
        // participants[_delegator].conferences.push(_conferenceName);
        // emit MyNewConference(_delegator, _conferenceName);

        if (conf.curPerson >= conf.maxPerson) {
            conf.canRegister = false;
            emit ConferenceExpire(_conferenceName);
        }
    }

    // administrator
    function newConference(string memory _name, string memory _detail, uint _maxPerson) public onlyAdministrator {
        require(_maxPerson > 0, "Maximum participant number must > 0.");
        conferences.push(Conference({
            name: _name,
            maxPerson: _maxPerson,
            curPerson: 0,
            canRegister: true,
            detail: _detail
        }));
        emit NewConference(_name);
    }
    // function destruct() private onlyAdministrator {
    //     selfdestruct(payable(administrator));
    // }
    function destruct() public payable onlyAdministrator {
        require(msg.sender == administrator);
        (bool success,) = payable(administrator).call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    // search functions
    function queryConfList() public view returns (Conference[] memory){
        uint cnt = 0;
        for(uint i = 0;i<conferences.length;i++){
            if(conferences[i].canRegister){
                cnt++;
            }
        }
        Conference[] memory openConfs = new Conference[](cnt);
        uint idx = 0;
        for (uint j=0 ;j<conferences.length;j++){
            if(conferences[j].canRegister){
                openConfs[idx] = conferences[j];
                idx++;
            }
        }
        return openConfs;
    }


    function queryMyConf() public view returns (string[] memory) {
        return participants[msg.sender].conferences;
    }

    function getParticipantName(address _participant) public view returns (string memory) {
        return participants[_participant].name;
    }
    function getParticipantConfList(address _participant) public view returns (string[] memory) {
        return participants[_participant].conferences;
    }
}