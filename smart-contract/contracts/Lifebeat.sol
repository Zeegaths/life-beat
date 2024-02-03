// contracts/Lifebeat.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


// Declaring state variables
contract Lifebeat {
    string public tokenName;
    string public symbol;
    uint256 public decimal;
    uint256 public tokenSupply;
    address public owner;


    mapping(address => uint)public balanceOf;
    mapping(address => mapping (address => uint)) public allowance;

    constructor () {
        tokenName = "Lifebeats";
        symbol = "LB";
        decimal = 18;
        tokenSupply = 500000;
        owner = msg.sender;
    }

    event transferEvents(
        address indexed sender, 
        address indexed receiver,
        uint256 amount
    );

     event approvalEvents(
        address indexed _sender, 
        address indexed _receiver,
        uint256 _amount
    );
  

    //asigning the contract owner as the sender
    modifier onlyOwner {
        require(msg.sender == owner, "You have to be the owner");
        _; 
    } 


    //Transfer tokens from one account to another
    function transfer(address receiver, uint amount) public {
        require( balanceOf[msg.sender] >= amount, "Insufficient funds");        
        balanceOf[msg.sender] -= amount;
        balanceOf[receiver] += amount;
        emit transferEvents(msg.sender, receiver, amount);
    }

    //adds to the token supply
    function mint(uint256 _amount) onlyOwner public view{
       _amount += tokenSupply;
    }    

    //removes tokens from the token supply
    function burn(uint256 _amount) onlyOwner public view {
        require(_amount <= tokenSupply,"");
        _amount -= tokenSupply;
    }    
  
    function approval(address _receiver, uint256 _amount) public {
        allowance[msg.sender][_receiver] = _amount;
        emit approvalEvents(msg.sender,_receiver, _amount);        
    }

    //allow transfer of tokens among accounts
    function transferFrom(address sender, address receiver, uint256 amount)public { 
        require(amount <= allowance[msg.sender][sender],"Transfer failed");
        allowance[msg.sender][sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[receiver] += amount; 
        emit transferEvents(sender, receiver, amount);
    } 
}