import random

from nose.tools import *
from ods.arraystack import ArrayStack
from listtest import list_test

def test_as():
    list_test(ArrayStack())
    