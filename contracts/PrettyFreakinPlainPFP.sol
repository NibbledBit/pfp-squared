// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PrettyFreakinPlainPFP is ERC721, ERC721URIStorage, Ownable {
    mapping(uint256 => pfpns.ProfilePicture) tokenIdToPfp;
    mapping(uint256 => bool) dnaClaimed;
    mapping(bytes32 => uint256) requestIdToTokenId;

    uint256 currentSupply;
    uint256 maxSupply;

    uint256 mintingFee;

    event pfpCreated(address owner, uint256 tokenId);

    constructor() ERC721("Test PFP", "PFP0") {
        maxSupply = 10000;
        currentSupply = 0;
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

        pfpns.ProfilePicture memory newPfp = tokenIdToPfp[currentSupply];
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

        bool claimed = dnaClaimed[dna];
        require(claimed == false);

        dnaClaimed[dna] = true;
        tokenIdToPfp[currentSupply] = newPfp;

        _safeMint(msg.sender, currentSupply);

        currentSupply += 1;
        uint256 change = msg.value - mintingFee;
        payable(msg.sender).transfer(change);
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
        pfpns.ProfilePicture memory newPfp = tokenIdToPfp[currentSupply];
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
        return !dnaClaimed[dna];
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

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}

library pfpns {
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
        Triangle
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
        Happy,
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
