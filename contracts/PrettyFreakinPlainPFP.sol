// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.7/VRFConsumerBase.sol";

contract PrettyFreakinPlainPFP is ERC721, VRFConsumerBase {
    event requestedCollectible(bytes32 indexed requestId, address requester);

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
    ) public {
        pfpns.ProfilePicture memory newPfp = varData.tokedIdToPfp[
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

        varData.mintCalls = varData.mintCalls + 1;

        bytes32 requestId = requestRandomness(varData.keyhash, varData.fee);
        varData.requestIdToSender[requestId] = msg.sender;
        varData.dnaClaimed[dna] = true;

        emit requestedCollectible(requestId, msg.sender);
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
        pfpns.ProfilePicture memory newPfp = varData.tokedIdToPfp[
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
        return varData.dnaClaimed[dna];
    }
}

library pfpns {
    struct Vars {
        bytes32 keyhash;
        uint256 fee;
        mapping(uint256 => pfpns.ProfilePicture) tokedIdToPfp;
        mapping(uint256 => bool) dnaClaimed;
        mapping(bytes32 => address) requestIdToSender;
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
