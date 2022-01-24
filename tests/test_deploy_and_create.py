from brownie import network, PrettyFreakinPlainPFP, config, exceptions
from scripts.deploy import deploy_pfp_nft
from scripts.helpful_scripts import (
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    get_publish_account,
    get_personal_account,
    get_contract,
    fund_with_link,
    deploy_mocks,
)
import pytest


def test_setting_tokenuri():
    pfp_nft, creation_tx = deploy_pfp_and_create_nft()
    random_number = 777
    requestId = creation_tx.events["requestedCollectible"]["requestId"]
    get_contract("vrf_coordinator").callBackWithRandomness(
        requestId, random_number, pfp_nft, {"from": get_publish_account()}
    )
    pfp_nft.setTokenURI(0, "Testlocation", {"from": get_publish_account()})


def test_can_create():

    pfp_nft, creation_tx = deploy_pfp_and_create_nft()
    random_number = 777
    requestId = creation_tx.events["requestedCollectible"]["requestId"]
    get_contract("vrf_coordinator").callBackWithRandomness(
        requestId, random_number, pfp_nft, {"from": get_publish_account()}
    )
    assert pfp_nft.timesMinted() > 0


def test_duplicate_nft():
    personal_account = get_personal_account()
    print(f"Account {personal_account}")

    pfp_nft = deploy_pfp_nft()

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        {"from": personal_account, "value": 1.001 * 10 ** 18},
    )
    tx.wait(1)

    fund_with_link(pfp_nft.address)
    with pytest.raises(exceptions.VirtualMachineError):
        tx = pfp_nft.publicMint(
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            {"from": personal_account, "value": 1 * 10 ** 18},
        )
        tx.wait(1)


def test_has_money():
    personal_account = get_personal_account()
    print(f"Account {personal_account}")

    pfp_nft = deploy_pfp_nft()

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        {"from": personal_account, "value": 1.001 * 10 ** 18},
    )
    tx.wait(1)

    assert pfp_nft.balance() > 0


def test_dna_not_available():
    # Get Account
    personal_account = get_personal_account()
    print(f"Account {personal_account}")

    pfp_nft = deploy_pfp_nft()

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        {"from": personal_account, "value": 1.001 * 10 ** 18},
    )
    tx.wait(1)

    dna_available = pfp_nft.dnaAvailable(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    assert dna_available == False


def test_dna_available():
    # Get Account
    personal_account = get_personal_account()
    print(f"Account {personal_account}")

    pfp_nft = deploy_pfp_nft()

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        {"from": personal_account, "value": 1.001 * 10 ** 18},
    )
    tx.wait(1)

    dna_available = pfp_nft.dnaAvailable(0, 0, 1, 0, 0, 1, 0, 0, 0, 0)
    assert dna_available == True


def deploy_pfp_and_create_nft():
    # Get Account
    personal_account = get_personal_account()
    print(f"Account {personal_account}")

    pfp_nft = deploy_pfp_nft()

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        {"from": personal_account, "value": 1.001 * 10 ** 18},
    )
    tx.wait(1)

    return pfp_nft, tx
