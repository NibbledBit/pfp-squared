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

    tx = pfp_nft.publicMint(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {"from": personal_account})
    tx.wait(1)

    fund_with_link(pfp_nft.address)
    with pytest.raises(exceptions.VirtualMachineError):
        tx = pfp_nft.publicMint(
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {"from": personal_account}
        )
        tx.wait(1)


def deploy_pfp_and_create_nft():
    # Get Account
    personal_account = get_personal_account()
    print(f"Account {personal_account}")

    pfp_nft = deploy_pfp_nft()

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {"from": personal_account})
    tx.wait(1)

    return pfp_nft, tx
