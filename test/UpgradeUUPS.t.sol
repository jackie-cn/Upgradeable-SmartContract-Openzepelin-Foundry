// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/UupsUpgrade.sol";

contract UUPSTest is Test {
    UUPSProxy public proxy;
    ContractV1 public v1;
    ContractV2 public v2;
    address public proxyAddress;
    ContractV1 wrappedProxyV1;
    ContractV2 wrappedProxyV2;

    address public owner = address(0x123);

    function setUp() public {
        // Deploy V1
        v1 = new ContractV1();

        // Initialize data for the proxy
        bytes memory data = abi.encodeWithSignature(
            "initialize(address)",
            owner
        );

        // Deploy the proxy with V1's address
        proxy = new UUPSProxy(address(v1), data);

        // Store proxy address for later use
        proxyAddress = address(proxy);

        wrappedProxyV1 = ContractV1(proxyAddress);
    }

    function testInitialize() public view {
        // Check owner is correctly set
        address returnedOwner = wrappedProxyV1.owner();
        console.log(returnedOwner);
        assertEq(returnedOwner, owner);
    }

    function testSetTextV1() public {
        // Call setText through proxy
        wrappedProxyV1.setText();
        assertEq(wrappedProxyV1.text(), "old");
    }

    function testUpgradeToV2() public {
        // Deploy V2
        v2 = new ContractV2();
        wrappedProxyV2 = ContractV2(proxyAddress);
        // Impersonate the owner to call upgradeToAndCall
        vm.startPrank(owner);

        //upgrade
        // note that openzeppelin upgradable v5.0.0 Removed upgradeTo and upgrade functions,
        //and made upgradeToAndCallignore the data argument if it is empty.
        wrappedProxyV1.upgradeToAndCall(address(v2), "");

        // Stop impersonating the owner
        vm.stopPrank();

        // Call setText through proxy which now points to V2
        wrappedProxyV2.setText();

        assertEq(wrappedProxyV2.text(), "new");
    }
}
