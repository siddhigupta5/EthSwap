pragma solidity ^0.5.0;

import "./Token.sol";
contract EthSwap{
   string public name ="EthSwap Instant Exchange";
   Token public token;
   uint public rate=100; 
   
   event TokensPurchased(
      address account,
      address token ,
      uint amount,
      uint rate
   );
   event TokensSold(
      address account,
      address token ,
      uint amount,
      uint rate
   );
   constructor(Token _token)public{
      token=_token;

   }
   function buyTokens() public payable{
      //amount of ethereum*redemption rate(# of tokens they recieve for 1 ether)
      uint tokenAmount=msg.value * rate; 
      require(token.balanceOf(address(this))>=tokenAmount);
      token.transfer(msg.sender,tokenAmount);
      //Emit-an-event
      emit TokenPurchased(msg.sender,address(token),tokenAmount,rate); 
   }
   function sellTokens(uint _amount)public{
      //user can't sell more tokens than they have
      require(token.balanceOf(msg.sender)>=_amount);
      //calculate ether amount to be redeemed
      uint etherAmount=_amount/rate;

      //require that EthSwap has enough Ether
      require(address(this).balance>=etherAmount);
      token.transferFrom(msg.sender,address(this),_amount);
     //perform sale
     msg.sender.transfer(etherAmount); 
     //emit an event
     emit TokensSold(msg.sender,address(token),_amount,rate);
   }
}

