from brownie import DragonBornNFT, accounts, network, config
from scripts.helpful_scripts import get_account


def deploy_dragonborn():
    account = get_account()
    dragonborn = DragonBornNFT.deploy({"from": account})
    print(dragonborn)
    return dragonborn


def main():
    deploy_dragonborn()
