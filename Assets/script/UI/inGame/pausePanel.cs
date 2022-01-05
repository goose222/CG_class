using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class pausePanel : MonoBehaviour
{
    private AsyncOperation ao;
    private void Awake()
    {
        gameObject.SetActive(false);
        transform.Find("back").GetComponent<Button>().onClick.AddListener(() =>
        {
            Time.timeScale = 1f;
            EventCenter.Broadcast(EventDefine.IsShowList, true);
            Show(false);
        });
        
        transform.Find("quit").GetComponent<Button>().onClick.AddListener(() =>
        {
            Time.timeScale = 1f;
            ao = SceneManager.LoadSceneAsync("start");
        });

        transform.Find("music").GetComponent<Button>().onClick.AddListener(() =>
        {
            EventCenter.Broadcast(EventDefine.musicSelect, true);
            Show(false);
        });

        EventCenter.AddListener<bool>(EventDefine.pausePanelScene, Show);
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener<bool>(EventDefine.pausePanelScene, Show);
    }
    private void Show(bool value)
    {
        gameObject.SetActive(value);
    }
}
