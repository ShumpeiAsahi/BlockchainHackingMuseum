// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract dummyToken is ERC20 {
    constructor() ERC20("BlockChain Hacking Museum", "BHM") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}