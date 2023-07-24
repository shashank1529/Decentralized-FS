// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Upload {
    // ek particular address kis kis address ko access de
    // rha hai ya nhi de rhaa
    struct Access {
        address user;
        bool access;
    }
    mapping(address => string[]) value; // a map for that points which address stores what
    mapping(address => Access[]) accessList; // ye store kr rha hai ki ek address kis kis address ko accesss de rha hai
    mapping(address => mapping(address => bool)) ownership; // ye bta rha hai do address ke bich ka relation ki kon kisko access diya hai
    mapping(address => mapping(address => bool)) previousData;

    // function that helps to store the data;
    function add(address __user, string memory url) external {
        value[__user].push(url);
    }

    // jo ki allow krega ki maine kisi user ko access diya hai ki nai
    function allow(address user) external {
        // jo user is function ko allow krega wo msg.sender
        // and jisko access dega wo user
        ownership[msg.sender][user] = true;
        // agar mera prev data pehle se hi true hai to instead
        // pushing again and creating the same address again
        // we will just replace the address with true;
        if (previousData[msg.sender][user]) {
            for (uint i = 0; i < accessList[msg.sender].length; i++) {
                if (accessList[msg.sender][i].user == user) {
                    accessList[msg.sender][i].access = true;
                }
            }
        } else {
            accessList[msg.sender].push(Access(user, true));
            previousData[msg.sender][user] = true;
        }
    }

    // jisko hume apne files ka access nhi dena
    function disallow(address user) public {
        ownership[msg.sender][user] = false;
        for (uint i = 0; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == user) {
                accessList[msg.sender][i].access = false;
            }
        }
    }

    // jo humare imgaes ko display krega!!
    function display(address _user) external view returns (string[] memory) {
        // for error handling purpose we use require keyword in blockchain
        require(
            _user == msg.sender || ownership[_user][msg.sender],
            "You dont have access"
        );
        return value[_user]; // return tha string;
    }

    function shareAccess() public view returns (Access[] memory) {
        return accessList[msg.sender];
    }
}
