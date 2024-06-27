// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 引入OpenZeppelin的库
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// 引入OpenZeppelin的ERC1967Proxy合约
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UUPSProxy is ERC1967Proxy {
    constructor(
        address _implementation,
        bytes memory _data
    ) ERC1967Proxy(_implementation, _data) {}
}

contract ContractV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    string public text;

    // 禁用构造函数初始化器，确保合约不会在部署时初始化
    constructor() {
        _disableInitializers();
    }

    // 初始化函数，作为构造函数的替代品
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner); // 设置合约所有者为msg.sender
        __UUPSUpgradeable_init(); // 初始化UUPS可升级模块
    }

    function setText() public {
        text = "old";
    }

    // 授权升级函数，只有合约所有者可以调用
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}

contract ContractV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    string public text;

    // 禁用构造函数初始化器，确保合约不会在部署时初始化
    constructor() {
        _disableInitializers();
    }

    // 初始化函数，作为构造函数的替代品
    function initialize(address _owner) public initializer {
        __Ownable_init(_owner); // 设置合约所有者为msg.sender
        __UUPSUpgradeable_init(); // 初始化UUPS可升级模块
    }

    function setText() public {
        text = "new";
    }

    // 授权升级函数，只有合约所有者可以调用
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
