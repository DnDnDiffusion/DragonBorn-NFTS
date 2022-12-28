from scripts.helpful_scripts import get_account, LOCAL_BLOCKCHAIN_ENVIRONMENTS
from brownie import network
import pytest
from scripts.deploy import deploy_dragonborn


def test_can_deploy():
    account = get_account()
    dragonborn = deploy_dragonborn()
    assert dragonborn.owner() == account
