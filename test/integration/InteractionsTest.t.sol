// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("Hello World!");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        //vm.deal(USER, STARTING_BALANCE);
    }

    // Instead of funding directly with the functions, we fund using the
    // FundFundMe contract from Interactions.s.sol
    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        // Com que això és un test, cal passar-li l'adreça del contracte fundMe
        // Quan executes Interactions.s.sol amb forge script, no cal passar-li
        // l'agafarà de broadcast/DeployFundMe.s.sol/chainid
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        // Aquí passa el mateix amb l'adreça, com que és un test se li passa
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
