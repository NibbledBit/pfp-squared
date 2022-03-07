from brownie import network, PrettyFreakinPlainPFP, config

from scripts.helpful_scripts import get_contract, get_publish_account


def deploy_contract():
    # Get Account
    publish_account = get_publish_account()
    print(f"Account {publish_account}")

    # configure dependencies
    print(f"The active network is {network.show_active()}")

    print("Deploying PrettyFreakinPlainPFP")
    pfp_nft = PrettyFreakinPlainPFP.deploy(
        {"from": publish_account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )
    print(f"Deployed: {pfp_nft}")
    return pfp_nft


def main():
    deploy_contract()
