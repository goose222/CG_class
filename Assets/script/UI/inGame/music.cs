using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class music : MonoBehaviour
{
    private void Awake()
    {
        gameObject.SetActive(false);
        EventCenter.AddListener<bool>(EventDefine.musicSelect, Show);
        transform.Find("back").GetComponent<Button>().onClick.AddListener(() =>
        {
            EventCenter.Broadcast(EventDefine.pausePanelScene, true);
            Show(false);
        });
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener<bool>(EventDefine.musicSelect, Show);
    }
    private void Show(bool value)
    {
        gameObject.SetActive(value);
    }
}
