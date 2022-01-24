// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.7/VRFConsumerBase.sol";

contract PrettyFreakinPlainPFP is ERC721, VRFConsumerBase {
    event requestedCollectible(bytes32 indexed requestId, address requester);

    address public owner;

    function timesMinted() public view returns (uint256) {
        return varData.mintCalls;
    }

    pfpns.Vars public varData;

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _fee
    )
        public
        VRFConsumerBase(_vrfCoordinator, _linkToken)
        ERC721("Test PFP", "PFP0")
    {
        varData.mintCalls = 0;
        varData.randomCalls = 0;
        varData.keyhash = _keyHash;
        varData.fee = _fee;
        owner = msg.sender;
    }

    function publicMint(
        pfpns.BackgroundColour bg,
        pfpns.FaceShape face,
        pfpns.SkinColour skin,
        pfpns.EyeShape eyeShape,
        pfpns.EyeColour eyeColour,
        pfpns.NoseShape nose,
        pfpns.Mouth mouth,
        pfpns.HairStyle style,
        pfpns.HairColour color,
        pfpns.FacialHair facialHair
    ) public payable {
        require(msg.value > 1 * 10**18, "1 ETH to mint a pfp");

        pfpns.ProfilePicture memory newPfp = varData.tokenIdToPfp[
            varData.mintCalls
        ];
        newPfp.bgColour = bg;
        newPfp.face = face;
        newPfp.skin = skin;
        newPfp.eyeShape = eyeShape;
        newPfp.eyeColour = eyeColour;
        newPfp.nose = nose;
        newPfp.mouth = mouth;
        newPfp.hairStyle = style;
        newPfp.hairColour = color;
        newPfp.facialHair = facialHair;

        uint256 dna = getDna(newPfp);

        bool claimed = varData.dnaClaimed[dna];

        require(claimed == false);

        bytes32 requestId = requestRandomness(varData.keyhash, varData.fee);
        varData.dnaClaimed[dna] = true;
        varData.tokenIdToPfp[varData.mintCalls] = newPfp;
        varData.requestIdToTokenId[requestId] = varData.mintCalls;

        emit requestedCollectible(requestId, msg.sender);

        _safeMint(msg.sender, varData.mintCalls);

        varData.mintCalls = varData.mintCalls + 1;
    }

    function getDna(pfpns.ProfilePicture memory pfp)
        public
        pure
        returns (uint256)
    {
        uint256 dnaBuilder = uint256(pfp.face) << 0;
        dnaBuilder = dnaBuilder + (uint256(pfp.skin) << 3);
        dnaBuilder = dnaBuilder + (uint256(pfp.eyeShape) << 6);
        dnaBuilder = dnaBuilder + (uint256(pfp.eyeColour) << 8);
        dnaBuilder = dnaBuilder + (uint256(pfp.nose) << 11);
        dnaBuilder = dnaBuilder + (uint256(pfp.mouth) << 14);

        return dnaBuilder;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        varData.randomCalls = varData.randomCalls + 1;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI)
        public
        onlyOwner
    {
        _setTokenURI(tokenId, _tokenURI);
    }

    function dnaAvailable(
        pfpns.BackgroundColour bg,
        pfpns.FaceShape face,
        pfpns.SkinColour skin,
        pfpns.EyeShape eyeShape,
        pfpns.EyeColour eyeColour,
        pfpns.NoseShape nose,
        pfpns.Mouth mouth,
        pfpns.HairStyle style,
        pfpns.HairColour color,
        pfpns.FacialHair facialHair
    ) public view returns (bool) {
        pfpns.ProfilePicture memory newPfp = varData.tokenIdToPfp[
            varData.mintCalls
        ];
        newPfp.bgColour = bg;
        newPfp.face = face;
        newPfp.skin = skin;
        newPfp.eyeShape = eyeShape;
        newPfp.eyeColour = eyeColour;
        newPfp.nose = nose;
        newPfp.mouth = mouth;
        newPfp.hairStyle = style;
        newPfp.hairColour = color;
        newPfp.facialHair = facialHair;

        uint256 dna = getDna(newPfp);
        return !varData.dnaClaimed[dna];
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
    }
}

library pfpns {
    struct Vars {
        bytes32 keyhash;
        uint256 fee;
        mapping(uint256 => pfpns.ProfilePicture) tokenIdToPfp;
        mapping(uint256 => bool) dnaClaimed;
        mapping(bytes32 => uint256) requestIdToTokenId;
        uint256 mintCalls;
        uint256 randomCalls;
    }

    struct ProfilePicture {
        // background elements
        BackgroundColour bgColour;
        // identity
        FaceShape face;
        SkinColour skin;
        EyeShape eyeShape;
        EyeColour eyeColour;
        NoseShape nose;
        Mouth mouth;
        HairStyle hairStyle;
        HairColour hairColour;
        FacialHair facialHair;
        //clothing
        uint8 jumperId;
        //special traits
        uint8 trait1;
        uint8 trait2;
        uint8 trait3;
    }

    enum BackgroundColour {
        Yellow,
        Blue,
        Red,
        Purple,
        Orange,
        Green
    }
    enum FaceShape {
        Round,
        Oval,
        Diamond,
        Square,
        Heart,
        Rectangle,
        Triagle
    }
    enum SkinColour {
        WhitePale,
        Fair,
        Medium,
        Olive,
        Brown,
        BlackBrown,
        Green
    }
    enum EyeShape {
        Upturned,
        Round,
        Downturned,
        Monolid
    }
    enum NoseShape {
        ThinUp,
        MediumUp,
        WideUp,
        ThinDown,
        MediumDown,
        WideDown
    }
    enum EyeColour {
        Blue,
        Brown,
        Green,
        Black,
        Red,
        Purple,
        White
    }
    enum Mouth {
        Neutral,
        Smile,
        Grumpy
    }
    enum HairStyle {
        Bald,
        Short,
        Long
    }
    enum HairColour {
        White,
        LightBlonde,
        DarkBlonde,
        LightBrunette,
        DarkBrunette,
        Grey,
        Black,
        Red,
        Green,
        Blue,
        Pink,
        Purple
    }
    enum FacialHair {
        None,
        Moustache,
        Stubble,
        Goatee,
        ShortBeard,
        LongBeard
    }
}
