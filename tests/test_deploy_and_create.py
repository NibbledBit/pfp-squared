from brownie import network, PrettyFreakinPlainPFP, config
from scripts.helpful_scripts import (
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    get_account,
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
        requestId, random_number, pfp_nft, {"from": get_account()}
    )
    assert pfp_nft.mintCalls() > 0
    assert pfp_nft.randomCalls() > 0


def deploy_pfp_and_create_nft():
    # Get Account
    print("Getting account")
    account = get_account()
    print(f"Account {account}")

    # configure dependencies
    print(f"The active network is {network.show_active()}")

    print("Deploying PrettyFreakinPlainPFP")
    pfp_nft = PrettyFreakinPlainPFP.deploy(
        get_contract("vrf_coordinator"),
        get_contract("link_token"),
        config["networks"][network.show_active()]["keyhash"],
        config["networks"][network.show_active()]["fee"],
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(f"Contract deployed to {pfp_nft}")
    print(f"Token Counter: {pfp_nft.tokenCounter()}")

    fund_with_link(pfp_nft.address)

    tx = pfp_nft.publicMint(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {"from": account})
    tx.wait(1)

    return pfp_nft, tx
