from src.udf.helpers import percentage_increase

def test_percentage_increase_negative_if_a_gt_b():
    assert percentage_increase(10, 5) == -1

def test_percentage_increase_negative_if_b_gt_a():
    assert percentage_increase(5, 10) == 0.5