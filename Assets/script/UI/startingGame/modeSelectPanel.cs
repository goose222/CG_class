using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class modeSelectPanel : MonoBehaviour
{
    private void Awake() 
    {
        gameObject.SetActive(false);
        EventCenter.AddListener<bool>(EventDefine.IsShowModeChoosePanel,Show);
        transform.Find("back").GetComponent<Button>().onClick.AddListener(() =>
        {
            EventCenter.Broadcast(EventDefine.IsShowStartPanel, true);
            Show(false);
        });
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener<bool>(EventDefine.IsShowModeChoosePanel, Show);
    }
    private void Show(bool value)
    {
        gameObject.SetActive(value);
    }
}
