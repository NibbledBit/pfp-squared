// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.7/VRFConsumerBase.sol";

contract PrettyFreakinPlainPFP is ERC721, VRFConsumerBase {
    uint256 public tokenCounter;
    bytes32 public keyhash;
    uint256 public fee;

    mapping(uint256 => ProfilePicture) public tokedIdToPfp;

    mapping(bytes32 => address) public requestIdToSender;
    event requestedCollectible(bytes32 indexed requestId, address requester);

    uint256 public mintCalls;
    uint256 public randomCalls;

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
        tokenCounter = 0;
        mintCalls = 0;
        randomCalls = 0;
        keyhash = _keyHash;
        fee = _fee;
    }

    function publicMint(
        BackgroundColour bg,
        FaceShape face,
        SkinColour skin,
        EyeShape eyeShape,
        EyeColour eyeColour,
        NoseShape nose,
        Mouth mouth,
        HairStyle style,
        HairColour color,
        FacialHair facialHair
    ) public {
        ProfilePicture storage newPfp = tokedIdToPfp[tokenCounter];
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

        mintCalls = mintCalls + 1;

        bytes32 requestId = requestRandomness(keyhash, fee);
        requestIdToSender[requestId] = msg.sender;
        emit requestedCollectible(requestId, msg.sender);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        randomCalls = randomCalls + 1;
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
