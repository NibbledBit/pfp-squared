from scripts.deploy import deploy_contract
from brownie import PrettyFreakinPlainPFP


def test_deploy():
    deploy_contract()
    nft = PrettyFreakinPlainPFP[-1]
    assert nft is not None
