using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class startPanel : MonoBehaviour
{
    // Start is called before the first frame update
    private void Awake()
    {
        transform.Find("mode").GetComponent<Button>().onClick.AddListener(() =>
        {
            EventCenter.Broadcast(EventDefine.IsShowModeChoosePanel, true);
            Show(false);
        });
        transform.Find("start").GetComponent<Button>().onClick.AddListener(() =>
        {
            EventCenter.Broadcast(EventDefine.StartLoadScene);
            Show(false);
        });
        transform.Find("quit").GetComponent<Button>().onClick.AddListener(() =>
        {
            #if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
            Application.Quit();
            #endif
        });
        EventCenter.AddListener<bool>(EventDefine.IsShowStartPanel, Show);
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener<bool>(EventDefine.IsShowStartPanel, Show);
    }
    private void Show(bool value)
    {
        gameObject.SetActive(value);
    }
}
