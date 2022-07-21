// SPDX-License-Identifier: MIT

import "./Dependencies.sol";

pragma solidity ^0.8.11;


contract TenETHGiveaway is ERC721, Ownable {
  address private royaltyBenificiary;
  uint16 private royaltyBasisPoints = 1000;

  string public constant redeemedImage = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><rect width="100%" height="100%" fill="#000"/></svg>';
  string public constant nonRedeemedImage = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><style>.size{x:calc(500px - (820px / 2));y:calc(500px - (550px / 2));width:820px;height:550px}.bg{width:100%;height:100%;fill:#ebfbee}#button{animation:1s infinite pulsing,3s infinite hrotate}#button:hover .button-rect{animation:1s infinite pulsing;stroke:#00f;fill:#fff}.button-rect{cursor:pointer;rx:50px;stroke:#00f;fill:#fffd00}.shadow-rect{rx:50px;fill:#444;animation:1s infinite pulsing-shadow}.text{font:bold 90px sans-serif;fill:#00f;text-anchor:middle;pointer-events:none;cursor:pointer}.em{font:italic bold 110px sans-serif;text-decoration:underline}@keyframes pulsing{0%,100%{transform:scale(1) translate(0,0);stroke-width:15px}70%{transform:scale(1.034) translate(calc(-820px * .034 / 2 - 2px),calc(-550px * .034 / 2));stroke-width:21px}}@keyframes pulsing-shadow{0%{transform:scale(1) translate(0,0);fill-opacity:1}70%{transform:scaleX(1.16) scaleY(1.2) translate(calc(-820px * .16 / 2 - 2px),calc(-550px * .16 / 2 - 32px));fill-opacity:0}100%{transform:scale(1) translate(0,0);fill-opacity:0}}@keyframes hrotate{0%,100%{filter:hue-rotate(0deg)}23.1%{filter:hue-rotate(45deg)}33.3%{filter:hue-rotate(40deg)}56.4%{filter:hue-rotate(100deg)}66.6%{filter:hue-rotate(90deg)}89.7%{filter:hue-rotate(5deg)}}</style><linearGradient id="grad" gradientUnits="userSpaceOnUse" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" stop-color="#000" stop-opacity="0.25"/><stop offset="100%" stop-color="#ff0000" stop-opacity="0.5"/><animateTransform attributeName="gradientTransform" type="rotate" from="0 130 130" to="360 130 130" dur="2s" repeatCount="indefinite"/></linearGradient> <rect class="bg"/><rect x="0" y="0" width="100%" height="100%" fill="url(#grad)"/><rect class="shadow-rect size"/> <g id="button" class="size"><rect class="button-rect color size"/><text class="text" x="50%" y="41.5%">REDEEM THIS</text><text class="text" x="50%" y="52.5%">TOKEN FOR</text><text class="text em" x="50%" y="65.5%">10 ETH</text></g></svg>';
  string public description = 'If you own this token, then call the \\"redeem\\" function on this contract to receive your 10 ETH!';
  string public script = 'let voices;try{voices=window.speechSynthesis.getVoices()}catch(a){}document.getElementById("button").onclick=()=>{document.body.innerHTML=`<h1 style="padding:0.5em;margin:0.5em;text-align:center;border:3px solid">${txt}</h1>`;try{let a=new window.SpeechSynthesisUtterance(txt);a.voice=voices[7],window.speechSynthesis.speak(a)}catch(b){}}';
  string public license = 'CC BY-NC 4.0';
  string public baseExternalUrl = 'https://10eth.0ms.co';
  bool public exists = false;

  uint private immutable tenEth = 10 ether;
  // uint private immutable tenEth = 0.001 ether;

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

    bytes memory encodedImage = abi.encodePacked('"image": "data:image/svg+xml;base64,', Base64.encode(getSVG()), '",');
    bytes memory encodedHTML = abi.encodePacked('"animation_url": "data:text/html;base64,', Base64.encode(getHTML()), '",');
    bytes memory attributes = abi.encodePacked('"attributes": [{"trait_type": "Redeemed", "value":"', exists ? 'false' : 'true', '"}],');

    string memory json = Base64.encode(
      abi.encodePacked(
        '{"name": "The 10 ETH Giveaway",',
        '"description": "', description, '",',
        attributes,
        encodedImage,
        encodedHTML,
        '"license": "', license, '",'
        '"external_url": "', baseExternalUrl,
        '"}'
      )
    );
    return string(abi.encodePacked('data:application/json;base64,', json));
  }

  function getSVG() public view returns (bytes memory) {
    return abi.encodePacked(
      exists ? nonRedeemedImage : redeemedImage
    );
  }

  function getHTML() public view returns (bytes memory) {
    return abi.encodePacked(
      '<!DOCTYPE html><html><style>*{margin:0;padding:0}</style><body style="display:flex;align-items:center;height:100vh;">',
      string(getSVG()),
      '</body><script type="text/javascript">const txt="', description, '";',
      script,
      '</script></html>'
    );
  }

  function setParams(
    string calldata _description,
    string calldata _license,
    string calldata _baseExternalUrl
  ) external onlyOwner {
    description = _description;
    license = _license;
    baseExternalUrl = _baseExternalUrl;
  }

  function setScript(string calldata _script) external onlyOwner {
    script = _script;
  }
}

