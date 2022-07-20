// SPDX-License-Identifier: MIT

import "./Dependencies.sol";

pragma solidity ^0.8.11;


contract TenETH is ERC721, Ownable {
  address private royaltyBenificiary;
  uint16 private royaltyBasisPoints = 1000;

  string public constant redeemedImage = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><rect width="100%" height="100%" fill="#000"/></svg>';
  string public constant nonRedeemedImage = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"> <style>.size{x: 62.5px; y: 275px; width: 875px; height: 450px;}.bg{width: 100%; height: 100%; fill: #ebfbee;}.button{animation: pulsing 1s infinite; cursor: pointer;}.button:hover{filter: hue-rotate(90deg);}.button-rect{rx: 50px; stroke-width: 15px; stroke: #00f; fill: #fffd00; cursor: pointer; transition: 300ms;}.button-rect:hover{stroke-width: 25px;}.shadow-rect{rx: 50px; fill: #444; animation: pulsing-shadow 1s infinite;}.delay{animation-delay: 0.3s;}.text{cursor: pointer; font: bold 80px sans-serif; fill: #00f; text-anchor: middle;}@keyframes pulsing{0%{transform: scale(1) translate(0, 0);}70%{transform: scale(1.034) translate(-14.875px, -7.65px);}100%{transform: scale(1) translate(0, 0);}}@keyframes pulsing-shadow{0%{transform: scale(1) translate(0, 0); fill-opacity: 1; height: 450px}70%{transform: scale(1.08) translate(-35px, -55px); fill-opacity: 0; height: 480px}100%{transform: scale(1) translate(0, 0); fill-opacity: 0; height: 450px}}</style> <rect class="bg"/> <g class="button size"> <rect class="shadow-rect size"/> <rect class="button-rect color size" id="button"/> <text class="text" x="50%" y="43%">CLICK HERE TO</text> <text class="text" x="50%" y="53%">MAKE 10 ETH</text> <text class="text" x="50%" y="63%">NOW</text> </g> <script type="text/javascript">document.getElementById("button").onclick=function (){window.alert("If you own this token, then call the \\"redeem\\" function on this contract to receive your 10 ETH!")}</script></svg>';
  string public constant description = 'If you own this token, then call the \\"redeem\\" function on this contract to receive your 10 ETH!';
  string public constant license = 'CC BY-NC 4.0';
  string public baseExternalUrl = 'https://10eth.0ms.co';
  bool public exists = false;

  // uint private immutable tenEth = 10 ether;
  uint private immutable tenEth = 0.001 ether;

  event ProjectEvent(address indexed poster, string indexed eventType, string content);
  event TokenEvent(address indexed poster, uint256 indexed tokenId, string indexed eventType, string content);

  constructor() ERC721('TenETH', '10E') {
    royaltyBenificiary = msg.sender;
  }

  function totalSupply() external view returns (uint256) {
    if (exists) {
      return 1;
    } else {
      return 0;
    }
  }

  function redeem() external {
    require(ownerOf(0) == msg.sender, "Caller is not token owner");
    _burn(0);
    exists = false;
    payable(msg.sender).transfer(tenEth);
  }

  function mint() external payable onlyOwner {
    require(msg.value == tenEth);
    require(!exists, 'Only one token can exist');
    exists = true;
    _mint(msg.sender, 0);
  }



  function emitTokenEvent(uint256 tokenId, string calldata eventType, string calldata content) external {
    require(
      owner() == _msgSender() || ERC721.ownerOf(tokenId) == _msgSender(),
      'Only project or token owner can emit token event'
    );
    emit TokenEvent(_msgSender(), tokenId, eventType, content);
  }

  function emitProjectEvent(string calldata eventType, string calldata content) external onlyOwner {
    emit ProjectEvent(_msgSender(), eventType, content);
  }


  function setRoyaltyInfo(
    address _royaltyBenificiary,
    uint16 _royaltyBasisPoints
  ) external onlyOwner {
    royaltyBenificiary = _royaltyBenificiary;
    royaltyBasisPoints = _royaltyBasisPoints;
  }

  // Only apply royalties on sales > 10 ETH
  function royaltyInfo(uint256, uint256 _salePrice) external view returns (address, uint256) {
    if (_salePrice > tenEth) {
      return (royaltyBenificiary, (_salePrice - tenEth) * royaltyBasisPoints / 10000);
    } else {
      return (royaltyBenificiary, 0);
    }
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
    // 0x2a55205a == ERC2981 interface id
    return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
  }


  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(tokenId == 0, 'ERC721Metadata: URI query for nonexistent token');

    string memory encodedImage = Base64.encode(
      abi.encodePacked(
        exists ? nonRedeemedImage : redeemedImage
      )
    );

    string memory json = Base64.encode(
      abi.encodePacked(
        '{"name": "10 ETH Guarantee",',
        '"attributes": [{"trait_type": "Redeemed", "value":"', exists ? 'false' : 'true', '"}],',
        '"description": "', description, '",',
        '"image": "data:image/svg+xml;base64,', encodedImage, '",',
        '"animation_url": "data:text/html;base64,', encodedImage, '",',
        // '"license": "', license, '",'
        '"external_url": "', baseExternalUrl,
        '"}'
      )
    );
    return string(abi.encodePacked('data:application/json;base64,', json));
  }

  function setBaseExternalUrl(string calldata _baseExternalUrl) external onlyOwner {
    baseExternalUrl = _baseExternalUrl;
  }
}

