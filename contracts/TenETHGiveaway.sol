// SPDX-License-Identifier: MIT

/*

 /$$$$$$$$ /$$                         /$$    /$$$$$$
|__  $$__/| $$                       /$$$$   /$$$_  $$
   | $$   | $$$$$$$   /$$$$$$       |_  $$  | $$$$\ $$
   | $$   | $$__  $$ /$$__  $$        | $$  | $$ $$ $$
   | $$   | $$  \ $$| $$$$$$$$        | $$  | $$\ $$$$
   | $$   | $$  | $$| $$_____/        | $$  | $$ \ $$$
   | $$   | $$  | $$|  $$$$$$$       /$$$$$$|  $$$$$$/
   |__/   |__/  |__/ \_______/      |______/ \______/


   /$$$$$$$$ /$$$$$$$$ /$$   /$$
  | $$_____/|__  $$__/| $$  | $$
  | $$         | $$   | $$  | $$
  | $$$$$      | $$   | $$$$$$$$
  | $$__/      | $$   | $$__  $$
  | $$         | $$   | $$  | $$
  | $$$$$$$$   | $$   | $$  | $$
  |________/   |__/   |__/  |__/


  /$$$$$$  /$$$$$$ /$$    /$$ /$$$$$$$$  /$$$$$$  /$$      /$$  /$$$$$$  /$$     /$$
 /$$__  $$|_  $$_/| $$   | $$| $$_____/ /$$__  $$| $$  /$ | $$ /$$__  $$|  $$   /$$/
| $$  \__/  | $$  | $$   | $$| $$      | $$  \ $$| $$ /$$$| $$| $$  \ $$ \  $$ /$$/
| $$ /$$$$  | $$  |  $$ / $$/| $$$$$   | $$$$$$$$| $$/$$ $$ $$| $$$$$$$$  \  $$$$/
| $$|_  $$  | $$   \  $$ $$/ | $$__/   | $$__  $$| $$$$_  $$$$| $$__  $$   \  $$/
| $$  \ $$  | $$    \  $$$/  | $$      | $$  | $$| $$$/ \  $$$| $$  | $$    | $$
|  $$$$$$/ /$$$$$$   \  $/   | $$$$$$$$| $$  | $$| $$/   \  $$| $$  | $$    | $$
 \______/ |______/    \_/    |________/|__/  |__/|__/     \__/|__/  |__/    |__/


  by steviep.eth

  If you own the 10 ETH Giveaway Token, then call the "redeem" function on this contract to receive 10 ETH!
  No tricks.
  No scams.
  No games.
  Just 10 ETH directly in your wallet.
  And you only need to own this one NFT to get it.
  Hi, I'm Steve Pikelny.
  And I want to give you 10 ETH of my hard earned money.
  That's right. You heard me correctly.
  I have 10 ETH just lying around with your name written all over it.
  That's 10 big, fat, juicy Ethers.
  All for redeeming a simple NFT.
  100% Guaranteed.
  Don't believe me? Take a look at the smart contract.
  When I told my lawyers, accountants, and top business advisors what I wanted to do, they said: "Steve! Are you crazy?! Doing this would be financial suicide!"
  But I didn't get to where I am today by playing it safe.
  What my advisors don't know is that from a business standpoint, this is a no-brainer.
  So why am I doing this?
  I'll tell you. But first, I want you to do one thing for me:
  Close your eyes.
  Imagine the feeling of that FREE 10 ETH entering your wallet.
  Imagine the warm, smooth feeling of joy that it sparks in your heart, radiating from the center of your body and making its way through each and every blood vessel.
  Imagine how it feels.
  Imagine how it tastes.
  Imagine how it smells.
  Now open your eyes. What do you see?
  That's right: You see a 10 ETH guarantee looking you square in the face.
  Frankly, you can't afford to miss this opportunity.
  The information provided on this site is for informational purposes only and may not be suitable as investment advice.

*/

import "./Dependencies.sol";

pragma solidity ^0.8.11;

contract TenETHGiveaway is ERC721, Ownable {
  string public constant redeemedImage = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><rect width="100%" height="100%" fill="#000"/></svg>';
  string public constant nonRedeemedImage = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><style>.size{x:calc(500px - (820px / 2));y:calc(500px - (550px / 2));width:820px;height:550px}.bg{width:100%;height:100%;fill:#ebfbee}#button{animation:1s infinite pulsing,3s infinite hrotate}#button:hover .button-rect{animation:1s infinite pulsing;stroke:#00f;fill:#fff}.button-rect{cursor:pointer;rx:50px;stroke:#00f;fill:#fffd00}.shadow-rect{rx:50px;fill:#444;animation:1s infinite pulsing-shadow}.text{font:bold 90px sans-serif;fill:#00f;text-anchor:middle;pointer-events:none;cursor:pointer}.em{font:italic bold 110px sans-serif;text-decoration:underline}@keyframes pulsing{0%,100%{transform:scale(1) translate(0,0);stroke-width:15px}70%{transform:scale(1.034) translate(calc(-820px * .034 / 2 - 2px),calc(-550px * .034 / 2));stroke-width:21px}}@keyframes pulsing-shadow{0%{transform:scale(1) translate(0,0);fill-opacity:1}70%{transform:scaleX(1.16) scaleY(1.2) translate(calc(-820px * .16 / 2 - 2px),calc(-550px * .16 / 2 - 32px));fill-opacity:0}100%{transform:scale(1) translate(0,0);fill-opacity:0}}@keyframes hrotate{0%,100%{filter:hue-rotate(0deg)}23.1%{filter:hue-rotate(45deg)}33.3%{filter:hue-rotate(40deg)}56.4%{filter:hue-rotate(100deg)}66.6%{filter:hue-rotate(90deg)}89.7%{filter:hue-rotate(5deg)}}</style><linearGradient id="grad" gradientUnits="userSpaceOnUse" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" stop-color="#000" stop-opacity="0.25"/><stop offset="100%" stop-color="#ff0000" stop-opacity="0.5"/><animateTransform attributeName="gradientTransform" type="rotate" from="0 130 130" to="360 130 130" dur="2s" repeatCount="indefinite"/></linearGradient> <rect class="bg"/><rect x="0" y="0" width="100%" height="100%" fill="url(#grad)"/><rect class="shadow-rect size"/> <g id="button" class="size"><rect class="button-rect color size"/><text class="text" x="50%" y="41.5%">REDEEM THIS</text><text class="text" x="50%" y="52.5%">TOKEN FOR</text><text class="text em" x="50%" y="65.5%">10 ETH</text></g></svg>';
  string public constant description = 'If you own the 10 ETH Giveaway Token, then go to https://10eth.0ms.co/redeem and click the \\"REDEEM\\" button to receive 10 ETH!';
  string public constant tokenName = 'The 10 ETH Giveaway Token';
  string public script = 'let voices;try{voices=window.speechSynthesis.getVoices()}catch(a){}document.getElementById("button").onclick=()=>{document.body.innerHTML=`<h1 style="padding:0.5em;margin:0.5em;text-align:center;border:3px solid">${txt}</h1>`;try{let a=new window.SpeechSynthesisUtterance(txt);a.voice=voices[7],window.speechSynthesis.speak(a)}catch(b){}}';
  string public license = 'CC BY-NC 4.0';
  string public externalUrl = 'https://10eth.0ms.co';
  bool public exists = false;

  uint private immutable tenEth = 10 ether;

  event ProjectEvent(address indexed poster, string indexed eventType, string content);
  event TokenEvent(address indexed poster, string indexed eventType, string content);

  constructor() ERC721('TenETHGiveaway', '10ETH') {}

  function totalSupply() external view returns (uint256) {
    if (exists) {
      return 1;
    } else {
      return 0;
    }
  }

  function redeem() external {
    require(exists, "Token does not exist");
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


  function emitTokenEvent(string calldata eventType, string calldata content) external {
    require(
      owner() == msg.sender || ownerOf(0) == msg.sender,
      'Only project or token owner can emit token event'
    );
    emit TokenEvent(msg.sender, eventType, content);
  }

  function emitProjectEvent(string calldata eventType, string calldata content) external onlyOwner {
    emit ProjectEvent(msg.sender, eventType, content);
  }


  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(tokenId == 0, 'ERC721Metadata: URI query for nonexistent token');

    bytes memory encodedImage = abi.encodePacked('"image": "data:image/svg+xml;base64,', Base64.encode(getSVG()), '",');
    bytes memory encodedHTML = abi.encodePacked('"animation_url": "data:text/html;base64,', Base64.encode(getHTML()), '",');
    bytes memory attributes = abi.encodePacked('"attributes": [{"trait_type": "Redeemed", "value":"', exists ? 'false' : 'true', '"}],');

    string memory json = Base64.encode(
      abi.encodePacked(
        '{"name": "', tokenName, '",',
        '"description": "', description, '",',
        attributes,
        encodedImage,
        exists ? encodedHTML : encodedImage,
        '"license": "', license, '",'
        '"external_url": "', externalUrl,
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
      '<!DOCTYPE html><html><style>*{margin:0;padding:0}</style><body style="display:flex;align-items:center;justify-content:center;height:100vh;overflow:hidden">',
      string(getSVG()),
      '</body><script type="text/javascript">const txt="', description, '";',
      script,
      '</script></html>'
    );
  }

  function setParams(
    string calldata _license,
    string calldata _externalUrl
  ) external onlyOwner {
    license = _license;
    externalUrl = _externalUrl;
  }

  function setScript(string calldata _script) external onlyOwner {
    script = _script;
  }
}

